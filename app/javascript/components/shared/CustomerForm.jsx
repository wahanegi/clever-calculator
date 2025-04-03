import React, { useEffect, useState } from 'react'
import { Row, Col } from 'react-bootstrap'
import { PcDropdownSelect, PcIcon, PcInput } from '../ui'

export const CustomerForm = () => {
  const placeholder = 'Enter a company name'
  const defaultCustomer = {
    id: 0,
    company_name: '',
    full_name: '',
    // first_name: '',
    // last_name: '',
    email: '',
    position: '',
    address: '',
    notes: '',
  }
  const [customers, setCustomers] = useState([])
  const [customer, setCustomer] = useState(defaultCustomer)
  const [selectedCustomerID, setSelectedCustomerID] = useState(0)

  useEffect(() => {
    fetch('/api/v1/customers')
      .then((response) => response.json())
      .then((customersResponse) => {
        setCustomers(customersResponse.data)
      })
  }, [])

  const options = () => {
    if (!customers) return []

    return customers.map((customer) => ({
      value: customer.id,
      label: customer.attributes.company_name,
    }))
  }

  const handleCompanyChange = (e) => {
    setSelectedCustomerID(e.target.value)
    const selectedCustomer = customers.find((customer) => customer.id === e.target.value)

    if (selectedCustomer) {
      setCustomer({
        id: selectedCustomer.id,
        company_name: selectedCustomer.attributes.company_name,
        full_name: selectedCustomer.attributes.full_name,
        // first_name: selectedCustomer.attributes.first_name,
        // last_name: selectedCustomer.attributes.last_name,
        email: selectedCustomer.attributes.email,
        position: selectedCustomer.attributes.position,
        address: selectedCustomer.attributes.address,
        notes: selectedCustomer.attributes.notes,
      })
    }
  }

  const handleInputChange = (e) => {
    console.log(e)
    setCustomer({
      ...customer,
      [e.target.id]: e.target.value,
    })
  }

  if (!customers) return null

  const companyInputLabel = (
    <span>
      Company <span className="text-danger">*</span>
    </span>
  )

  return (
    <div className="border rounded border-primary customer-form bg-light">
      <Row className="mb-6">
        <div className="d-flex flex-column flex-sm-row gap-6">
          <Col className="image-placeholder w-100 bg-white border rounded border-primary p-1 d-flex justify-content-center align-items-center">
            <PcIcon name="placeholder" alt="Logo" />
          </Col>
          <Col>
            <Row className="mb-6">
              <Col>
                <PcDropdownSelect
                  id="company_name"
                  options={options()}
                  placeholder={placeholder}
                  height="42px"
                  label={companyInputLabel}
                  value={selectedCustomerID}
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
                    onChange={handleInputChange}
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
  )
}
