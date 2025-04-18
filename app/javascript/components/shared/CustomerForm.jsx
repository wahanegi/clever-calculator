import React, { useEffect, useState } from 'react'
import { Button, Col, Form, Row } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchCustomers, fetchQuotes } from '../services'
import { PcCompanyLogoUploader, PcDropdownSelect, PcInput } from '../ui'
import { extractNames } from '../utils'
import { ROUTES, STEPS } from './constants'

export const CustomerForm = () => {
  const defaultCustomer = {
    company_name: '',
    full_name: '',
    email: '',
    position: '',
    address: '',
    notes: '',
    logo: null,
  }
  const [customers, setCustomers] = useState([])
  const [customer, setCustomer] = useState(defaultCustomer)

  const [errors, setErrors] = useState({})

  const { navigate } = useAppHooks()

  useEffect(() => {
    fetchCustomers.index().then((customersResponse) => {
      setCustomers(customersResponse.data)
    })
  }, [])

  const options = customers.map((customer) => ({
    value: customer.id,
    label: customer.attributes.company_name,
  }))

  const validateForm = () => {
    const newErrors = {}

    if (!customer.company_name.trim()) {
      newErrors.company_name = 'Company name is required'
    }

    if (!!customer.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(customer.email)) {
      newErrors.email = 'Invalid email format'
    }

    setErrors(newErrors)

    return Object.keys(newErrors).length === 0
  }

  const handleCompanyChange = (e) => {
    const value = e.target.value
    const selectedCustomer = customers.find((customer) => customer.id === value)

    if (selectedCustomer) {
      setCustomer(selectedCustomer.attributes)
    } else {
      setCustomer({
        ...defaultCustomer,
        company_name: value,
      })
    }
  }

  const handleInputChange = (e) => {
    const { id, value } = e.target

    setCustomer({
      ...customer,
      [id]: value,
    })
    setErrors((prev) => ({ ...prev, [id]: '' }))
  }

  const handleChangeLogo = (e) => {
    const blobFile = e.target.files[0]

    setCustomer({
      ...customer,
      logo: blobFile ? URL.createObjectURL(blobFile) : null,
    })
  }

  const handleNext = async (e) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    const form = e.target
    const formData = new FormData()
    const { first_name, last_name } = extractNames(customer.full_name)
    const blobLogo = form[0].files[0]

    if (blobLogo) formData.append('customer[logo]', blobLogo)
    formData.append('customer[company_name]', customer.company_name)
    formData.append('customer[first_name]', first_name)
    formData.append('customer[last_name]', last_name)
    formData.append('customer[position]', customer.position)
    formData.append('customer[email]', customer.email)
    formData.append('customer[address]', customer.address)
    formData.append('customer[notes]', customer.notes)

    const { data: customerData } = await fetchCustomers.upsert(formData)

    if (!customers.some((c) => c.id === customerData.id)) {
      setCustomers((prev) => [...prev, customerData])
    }

    const { data: quoteData } = await fetchQuotes.create({
      quote: {
        customer_id: customerData.id,
        total_price: 0,
        step: STEPS.ITEM_PRICING,
      },
    })

    navigate(`${ROUTES.ITEM_PRICING}?quote_id=${quoteData.id}`)
  }

  if (!customers) return null

  const selectedCompany =
    customers.find((c) => c.attributes.company_name.toLowerCase() === customer.company_name.toLowerCase())?.id ||
    customer.company_name

  return (
    <Form onSubmit={handleNext} className={'d-flex flex-column w-100 align-items-center'}>
      <div className="border rounded border-primary customer-form bg-light w-100 mb-10">
        <Row className="mb-8">
          <div className="d-flex flex-column flex-sm-row gap-8">
            <Col className={'image-placeholder'}>
              <PcCompanyLogoUploader id="company_logo" onChange={handleChangeLogo} logo={customer.logo} />
            </Col>
            <Col>
              <Row className="mb-8">
                <Col>
                  <PcDropdownSelect
                    id="company_name"
                    options={options}
                    placeholder="Enter a company name"
                    height="42px"
                    label={
                      <span>
                        Company <span className="text-danger">*</span>
                      </span>
                    }
                    value={selectedCompany}
                    error={errors.company_name}
                    onChange={handleCompanyChange}
                    onInputChange={handleInputChange}
                    hasIcon={true}
                  />
                </Col>
              </Row>
              <Row>
                <div className="d-flex flex-column flex-sm-row gap-8">
                  <Col className="client-input">
                    <PcInput
                      id="full_name"
                      placeholder="Client name"
                      label="Client"
                      height="42px"
                      value={customer.full_name}
                      onChange={(e) => {
                        const { value } = e.target
                        setCustomer({
                          ...customer,
                          ...extractNames(value),
                          full_name: value,
                        })
                      }}
                    />
                  </Col>
                  <Col className="title-input">
                    <PcInput
                      id="position"
                      placeholder="Position"
                      label="Client Title"
                      height="42px"
                      value={customer.position}
                      onChange={handleInputChange}
                    />
                  </Col>
                </div>
              </Row>
            </Col>
          </div>
        </Row>
        <Row className="mb-8">
          <div className="d-flex flex-column flex-sm-row gap-8">
            <Col>
              <PcInput
                id="email"
                type="email"
                placeholder="E-mail"
                label="E-mail"
                height="42px"
                value={customer.email}
                error={errors.email}
                onChange={handleInputChange}
              />
            </Col>
            <Col>
              <PcInput
                id="address"
                placeholder="Company address"
                label="Address"
                height="42px"
                value={customer.address}
                onChange={handleInputChange}
              />
            </Col>
          </div>
        </Row>
        <Row>
          <Col>
            <PcInput
              id="notes"
              as="textarea"
              placeholder="Important information"
              label="Notes"
              height="100px"
              value={customer.notes}
              onChange={handleInputChange}
            />
          </Col>
        </Row>
      </div>
      <Button type={'submit'} className="pc-btn" disabled={!customer.company_name}>
        Next
      </Button>
    </Form>
  )
}
