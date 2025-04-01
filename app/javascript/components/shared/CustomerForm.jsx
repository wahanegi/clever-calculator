import React from 'react'
import { Row, Col } from 'react-bootstrap'
import { PcIcon, PcInput } from '../ui'

export const CustomerForm = () => {
  return (
    <div className="border rounded border-primary customer-form bg-light">
      <Row className="mb-6">
        <div className="d-flex align-items-center gap-6">
          <Col className="image-placeholder w-100 bg-white border rounded border-primary p-1 d-flex justify-content-center align-items-center">
            <PcIcon name="placeholder" alt="Logo" />
          </Col>
          <Col>
            <Row className="mb-6">
              <Col>
                <PcInput
                  id="company"
                  type="select"
                  label="Company"
                  placeholder="Enter a company name"
                  height="42px"
                  options={[
                    { value: '1', label: 'One' },
                    { value: '2', label: 'Two' },
                    { value: '3', label: 'Three' },
                  ]}
                />
              </Col>
            </Row>
            <Row>
              <div className="d-flex gap-6">
                <Col className="client-input">
                  <PcInput id="client" placeholder="Client name" label="Client" height="42px" />
                </Col>
                <Col className="title-input">
                  <PcInput id="clientTitle" placeholder="Position" label="Client Title" height="42px" />
                </Col>
              </div>
            </Row>
          </Col>
        </div>
      </Row>
      <Row className="mb-6">
        <div className="d-flex gap-6">
          <Col>
            <PcInput id="email" type="email" placeholder="E-mail" label="E-mail" height="42px" />
          </Col>
          <Col>
            <PcInput id="address" placeholder="Company address" label="Address" height="42px" />
          </Col>
        </div>
      </Row>
      <Row>
        <Col>
          <PcInput id="notes" as="textarea" placeholder="Important information" label="Notes" height="100px" />
        </Col>
      </Row>
    </div>
  )
}
