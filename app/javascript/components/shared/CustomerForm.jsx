import React, { useEffect, useState } from 'react'
import { Button, Col, Form, Row } from 'react-bootstrap'
import { PcDropdownSelect, PcInput, PcLogoUploader, PcInputTextarea } from '../ui'
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
    value: parseInt(customer.id),
    label: customer.attributes.company_name,
  }))

  const selectedCompany =
    customers.find((c) =>
      c.attributes.company_name.toLowerCase() === customer.company_name.toLowerCase(),
    )?.attributes.company_name || customer.company_name

  const handleCompanyChange = (selected) => {
    if (selected.length === 0) return

    const { value, label } = selected[0]
    const selectedCustomer = customers.find((customer) => parseInt(customer.id) === value)

    let newCompanyName = label

    if (selectedCustomer) {
      setCustomer(selectedCustomer.attributes)
      newCompanyName = selectedCustomer.attributes.company_name
    } else {
      setCustomer(prev => ({ ...prev, company_name: label }))
    }

    const errorMessage = newCompanyName.length > 50 ? 'Company name is too long (maximum is 50 characters)' : ''
    setErrors((prev) => ({
      ...prev,
      company_name: errorMessage,
    }))
    setIsNextDisabled(!!errorMessage) // Disable Next button if there’s an error
  }

  const handleCompanyInputChange = (text) => {
    text = text.trimStart()

    if (text) {
      const errorMessage = text.length > 50 ? 'Company name is too long (maximum is 50 characters)' : ''
      setErrors((prev) => ({
        ...prev,
        company_name: errorMessage,
      }))
      setIsNextDisabled(!!errorMessage) // Disable Next button if there’s an error
    } else {
      setIsNextDisabled(true)
      setErrors((prev) => ({ ...prev, company_name: 'Company name is required' }))
    }

    setCustomer((prev) => ({ ...prev, company_name: text }))
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

    if (value && !INPUT_VALIDATORS.emailFormat.test(value)) {
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
      setIsNextDisabled(false)
      setErrors((prev) => ({ ...prev, logo: '' }))
      return
    }

    const logoErrors = []

    if (file.size > INPUT_VALIDATORS.maxSizeFile) {
      logoErrors.push('Logo must be less than 2MB')
    }

    if (!INPUT_VALIDATORS.allowedFileTypes.includes(file.type)) {
      logoErrors.push('Logo must be a JPEG or PNG file')
    }

    if (logoErrors.length > 0) {
      setIsNextDisabled(true)
      setErrors((prev) => ({ ...prev, logo: logoErrors.join('\n') }))
    } else {
      setCustomer((prev) => ({ ...prev, logo_url: URL.createObjectURL(file) }))
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

  const handleClearInput = () => {
    setCustomer(prev => ({ ...prev, company_name: '' }))
    setErrors(prev => ({ ...prev, company_name: '' }))
    setIsNextDisabled(true)
  }

  return (
    <Form onSubmit={handleNext} className={'d-flex flex-column w-100 align-items-center'}>
      <div className="border rounded border-primary customer-form bg-light w-100 mb-10">
        <Row className="mb-8">
          <div className="d-flex flex-column flex-sm-row gap-8">
            <Col className={'image-placeholder mx-auto'}>
              <PcLogoUploader
                id="company_logo"
                onChange={handleLogoChange}
                accept={INPUT_VALIDATORS.allowedFileTypes.join(',')}
                logo={customer.logo_url}
                error={errors.logo} />
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
                    onInputChange={handleCompanyInputChange}
                    onClearInput={handleClearInput}
                    hasIcon={true}
                    labelKey="label"
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
                      onChange={handleFullNameChange}
                    />
                  </Col>
                  <Col className="title-input col">
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
            <PcInputTextarea
              id="notes"
              placeholder="Important information"
              label="Notes"
              value={customer.notes}
              onChange={handleInputChange}/>
          </Col>
        </Row>
      </div>

      <Button type={'submit'} className="pc-btn mb-4" disabled={isNextDisabled}>
        Next
      </Button>
    </Form>
  )
}
