import React, { useEffect, useState } from 'react'
import { Row, Col, Form, Button } from 'react-bootstrap'
import { PcDropdownSelect, PcIcon, PcInput } from '../ui'
import { ROUTES, STEPS } from './constants'
import { fetchCustomers, fetchQuotes } from '../services'
import { useAppHooks } from '../hooks'

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

  const handleLogoUpload = (e) => {
    setCustomer({ ...customer, logo: URL.createObjectURL(e.target.files[0]) })
  }

  const handleNext = async (e) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    const { data: customerData } = await fetchCustomers.upsert({
      customer: {
        company_name: customer.company_name,
        first_name: customer.first_name || customer.full_name?.split(' ')[0] || '',
        last_name: customer.last_name || customer.full_name?.split(' ')[1] || '',
        email: customer.email,
        position: customer.position,
        address: customer.address,
        notes: customer.notes,
      },
    })

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

  const companyInputLabel = (
    <span>
      Company <span className="text-danger">*</span>
    </span>
  )

  const extractNames = (fullName = '') => {
    const [first, ...rest] = fullName.trim().split(' ')
    return {
      first_name: first || '',
      last_name: rest.join(' ') || '',
    }
  }

  const selectedCompany =
    customers.find((c) => c.attributes.company_name.toLowerCase() === customer.company_name.toLowerCase())?.id ||
    customer.company_name

  const CompanyLogoUploader = () => (
    <Form.Group>
      <Form.Label className={'m-0'} column={'sm'}>
        {customer.logo ? (
          <img src={customer.logo} alt={`${customer.company_name} logo`} style={{ height: '100px', width: '100px' }} />
        ) : (
          <PcIcon name="placeholder" alt="Placeholder logo" />
        )}
        <Form.Control
          className={'d-none'}
          name="logo"
          type={'file'}
          accept={'image/jpeg,image/png'}
          onChange={handleLogoUpload}
        />
      </Form.Label>
    </Form.Group>
  )

  return (
    <>
      <div className="border rounded border-primary customer-form bg-light w-100 mb-7">
        <Row className="mb-6">
          <div className="d-flex flex-column flex-sm-row gap-6">
            <Col className="image-placeholder w-100 bg-white border rounded border-primary p-1 d-flex justify-content-center align-items-center">
              <CompanyLogoUploader />
            </Col>
            <Col>
              <Row className="mb-6">
                <Col>
                  <PcDropdownSelect
                    id="company_name"
                    options={options}
                    placeholder="Enter a company name"
                    height="42px"
                    label={companyInputLabel}
                    value={selectedCompany}
                    error={errors.company_name}
                    onChange={handleCompanyChange}
                    onInputChange={handleInputChange}
                    hasIcon={true}
                  />
                </Col>
              </Row>
              <Row>
                <div className="d-flex flex-column flex-sm-row gap-6">
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
        <Row className="mb-6">
          <div className="d-flex flex-column flex-sm-row gap-6">
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
      <Button onClick={handleNext} className="pc-btn-next" disabled={!customer.company_name}>
        Next
      </Button>
    </>
  )
}
