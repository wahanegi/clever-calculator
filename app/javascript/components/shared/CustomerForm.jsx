import React, { useState } from 'react'
import { Row, Col } from 'react-bootstrap'
import { PcDropdownSelect, PcIcon, PcInput } from '../ui'

// TODO Remove this after Customer is fetched from database
const CUSTOMER_EXAMPLE = {
  data: [
    {
      id: '1',
      type: 'customer',
      attributes: {
        company_name: 'Acme Corp',
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        position: 'Manager',
        address: '123 Main St, Springfield',
        notes: 'VIP client',
        created_at: '2024-04-02T12:00:00Z',
        updated_at: '2024-04-02T12:30:00Z',
      },
    },
    {
      id: '2',
      type: 'customer',
      attributes: {
        company_name: 'Globex Ltd',
        first_name: 'Jane',
        last_name: 'Smith',
        email: 'jane.smith@example.com',
        position: 'CEO',
        address: '456 Elm St, Metropolis',
        notes: 'Looking for long-term partnership',
        created_at: '2024-04-01T10:15:00Z',
        updated_at: '2024-04-01T11:00:00Z',
      },
    },
    {
      id: '3',
      type: 'customer',
      attributes: {
        company_name: 'Wayne Enterprises',
        first_name: 'Bruce',
        last_name: 'Wayne',
        email: 'bruce.wayne@example.com',
        position: 'Owner',
        address: '1007 Mountain Drive, Gotham',
        notes: 'High-priority client',
        created_at: '2024-03-30T08:45:00Z',
        updated_at: '2024-03-30T09:00:00Z',
      },
    },
  ],
}

export const CustomerForm = () => {
  const [formData, setFormData] = useState({
    company: '',
    client: '',
    clientTitle: '',
    email: '',
    address: '',
    notes: '',
  })
  const [companies, setCompanies] = useState(CUSTOMER_EXAMPLE.data)

  const handleChange = (e) => {
    const { id, value } = e.target

    setFormData((prev) => ({ ...prev, [id]: value }))

    if (id === 'company' && value) {
      const isExistingId = companies.some((c) => c.id === value)
      if (!isExistingId) {
        const existingCompany = companies.find((c) => c.attributes.company_name.toLowerCase() === value.toLowerCase())
        if (existingCompany) {
          setFormData((prev) => ({ ...prev, company: existingCompany.id }))
        }
      }
    }
  }

  const handleInputChange = (inputValue) => {
    if (inputValue) {
      setFormData((prev) => ({ ...prev, company: inputValue }))
    } else {
      setFormData((prev) => ({ ...prev, company: '' }))
    }
  }
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
                  id="company"
                  options={companies}
                  placeholder="Enter a company name"
                  height="42px"
                  label="Company"
                  value={formData.company}
                  onChange={handleChange}
                  onInputChange={handleInputChange}
                />
              </Col>
            </Row>
            <Row>
              <div className="d-flex flex-column flex-sm-row gap-6">
                <Col className="client-input">
                  <PcInput
                    id="client"
                    placeholder="Client name"
                    label="Client"
                    height="42px"
                    value={formData.client}
                    onChange={handleChange}
                  />
                </Col>
                <Col className="title-input">
                  <PcInput
                    id="clientTitle"
                    placeholder="Position"
                    label="Client Title"
                    height="42px"
                    value={formData.clientTitle}
                    onChange={handleChange}
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
              value={formData.email}
              onChange={handleChange}
            />
          </Col>
          <Col>
            <PcInput
              id="address"
              placeholder="Company address"
              label="Address"
              height="42px"
              value={formData.address}
              onChange={handleChange}
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
            value={formData.notes}
            onChange={handleChange}
          />
        </Col>
      </Row>
    </div>
  )
}
