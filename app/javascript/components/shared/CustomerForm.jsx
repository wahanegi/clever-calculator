import React from 'react'
import { Row, Col, Form } from 'react-bootstrap'
import { PcIcon } from '../ui'

export const CustomerForm = () => {
  return (
    <div className={'border rounded border-primary customer-form bg-light'}>
      <Row className={'mb-6'}>
        <div className={'d-flex align-items-center gap-6'}>
          <Col
            className={
              'image-placeholder w-100 bg-white border rounded border-primary p-1 d-flex justify-content-center align-items-center'
            }
          >
            <PcIcon name={'placeholder'} alt={'Logo'} />
          </Col>
          <Col>
            <Row className={'mb-6'}>
              <Col>
                <Form.Group controlId="company" className={'position-relative'}>
                  <Form.Select aria-label="Select company" className={'border border-primary rounded-1'}>
                    <option>Enter a company name</option>
                    <option value="1">One</option>
                    <option value="2">Two</option>
                    <option value="3">Three</option>
                  </Form.Select>
                  <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>
                    Company <span className="text-danger">*</span>
                  </Form.Label>
                </Form.Group>
              </Col>
            </Row>
            <Row>
              <div className={'d-flex gap-6'}>
                <Col className={'client-input'}>
                  <Form.Group controlId="client" className={'position-relative'}>
                    <Form.Control type="text" placeholder="Client name" className={'border border-primary rounded-1'} />
                    <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>Client</Form.Label>
                  </Form.Group>
                </Col>
                <Col className={'title-input'}>
                  <Form.Group controlId="client" className={'position-relative'}>
                    <Form.Control
                      type="text"
                      placeholder="Position"
                      className={'border border-primary rounded-1 w-100'}
                    />
                    <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>Client Title</Form.Label>
                  </Form.Group>
                </Col>
              </div>
            </Row>
          </Col>
        </div>
      </Row>
      <Row className={'mb-6'}>
        <div className="d-flex gap-6">
          <Col>
            <Form.Group controlId="email" className={'position-relative'}>
              <Form.Control type="email" placeholder="E-mail" className={'border border-primary rounded-1 w-100'} />
              <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>E-mail</Form.Label>
            </Form.Group>
          </Col>
          <Col>
            <Form.Group controlId="address" className={'position-relative'}>
              <Form.Control
                type="text"
                placeholder="Company address"
                className={'border border-primary rounded-1 w-100'}
              />
              <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>Address</Form.Label>
            </Form.Group>
          </Col>
        </div>
      </Row>
      <Row>
        <Col md={12}>
          <Form.Group controlId="notes" className={'position-relative notes_input'}>
            <Form.Control
              as="textarea"
              rows={3}
              placeholder="Important information"
              className={'border border-primary rounded-1 w-100 py-4'}
            />
            <Form.Label className={'border-label fw-bold fs-11 lh-sm px-1'}>Notes</Form.Label>
          </Form.Group>
        </Col>
      </Row>
    </div>
  )
}
