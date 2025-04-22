import React, { useEffect, useState } from 'react'
import { Row, Col, Form, Button } from 'react-bootstrap'
import { PcDropdownSelect, PcCompanyLogoUploader, PcInput } from '../ui'
import { EMPTY_ENTITIES, INPUT_VALIDATORS, ROUTES, STEPS } from './constants'
import { fetchCustomers, fetchQuotes } from '../services'
import { useAppHooks } from '../hooks'
import { extractNames } from '../utils'

export const CustomerForm = () => {
  const [customers, setCustomers] = useState([])
  const [customer, setCustomer] = useState(EMPTY_ENTITIES.customer)
  const [isNextDisabled, setIsNextDisabled] = useState(true)
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

  const selectedCompany =
    customers.find((c) => c.attributes.company_name.toLowerCase() === customer.company_name.toLowerCase())?.id ||
    customer.company_name

  const handleCompanyChange = (e) => {
    const { value } = e.target
    const selectedCustomer = customers.find((customer) => customer.id === value)

    if (selectedCustomer) {
      setCustomer(selectedCustomer.attributes)
    } else {
      setCustomer({
        ...EMPTY_ENTITIES.customer,
        company_name: value,
      })
    }

    setErrors((prev) => ({ ...prev, company_name: '' }))
  }

  const handleCompanyInputChange = (e) => {
    const { value } = e.target

    if (value) {
      setIsNextDisabled(false)
      setErrors((prev) => ({ ...prev, company_name: '' }))
    } else {
      setIsNextDisabled(true)
      setErrors((prev) => ({ ...prev, company_name: 'Company name is required' }))
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

  const handleEmailChange = (e) => {
    const { value } = e.target

    if (value && !INPUT_VALIDATORS.email.test(value)) {
      setIsNextDisabled(true)
      setErrors((prev) => ({ ...prev, email: 'Invalid email format' }))
    } else {
      setIsNextDisabled(false)
      setErrors((prev) => ({ ...prev, email: '' }))
    }

    setCustomer((prev) => ({ ...prev, email: value }))
  }

  const handleFullNameChange = (e) => {
    const { value } = e.target

    setCustomer((prev) => ({
      ...prev,
      ...extractNames(value),
      full_name: value,
    }))
  }

  const handleLogoChange = (e) => {
    const file = e.target.files[0]

    if (!file) {
      setErrors((prev) => ({ ...prev, logo: '' }))
      return
    }

    const logoErrors = []

    if (file.size > INPUT_VALIDATORS.maxSizeFile) {
      logoErrors.push('Logo must be less than 2MB')
    }

    if (!INPUT_VALIDATORS.fileType.includes(file.type)) {
      logoErrors.push('Logo must be a JPEG or PNG file')
    }

    if (logoErrors.length > 0) {
      setIsNextDisabled(true)
      setErrors((prev) => ({ ...prev, logo: logoErrors.join('\n') }))
    } else {
      setIsNextDisabled(false)
      setCustomer((prev) => ({
        ...prev,
        logo_file: file,
        logo_url: URL.createObjectURL(file),
      }))

      setErrors((prev) => ({ ...prev, logo: '' }))
    }
  }

  const handleNext = async (e) => {
    e.preventDefault()

    setIsNextDisabled(true) // disable next button while form is being submitted

    try {
      const { data: customerData } = await fetchCustomers.upsertUseFormData(customer)

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
    } catch (error) {
      const logoErrors = error?.response?.data?.errors || { errors: [] }

      setErrors(prev => ({ ...prev, ...logoErrors }))
    } finally {
      setIsNextDisabled(false) // enable next button
    }
  }

  return (
    <Form onSubmit={handleNext} className={'d-flex flex-column w-100 align-items-center'}>
      <div className="border rounded border-primary customer-form bg-light w-100 mb-7">
        <Row className="mb-6">
          <div className="d-flex flex-column flex-sm-row gap-6">
            <Col className={'image-placeholder'}>
              <PcCompanyLogoUploader
                id="company_logo"
                onChange={handleLogoChange}
                accept={INPUT_VALIDATORS.fileType.join(',')}
                logo={customer.logo_url}
                error={errors.logo} />
            </Col>
            <Col>
              <Row className="mb-6">
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
                    onInputChange={handleCompanyInputChange}
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
                      onChange={handleFullNameChange}
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
                onChange={handleEmailChange}
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
      <Button type={'submit'} className="pc-btn-next" disabled={isNextDisabled}>
        Next
      </Button>
    </Form>
  )
}
