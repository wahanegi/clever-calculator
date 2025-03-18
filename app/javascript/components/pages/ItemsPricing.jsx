import React from 'react'
import { Container, Row } from 'react-bootstrap'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'
import { PcButton } from '../ui'

export const ItemsPricing = () => {
  const navigate = useNavigate()
  const handleNext = () => {
    console.log('Data was downloaded')
  }

  const handleBack = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container className={'wrapper'}>
      {/* Title & progress bar */}
      <section className={'px-6 mb-2'}>
        <div className={'d-flex justify-content-between mb-6'}>
          <h1>Items Pricing Page</h1>
          <PcButton variant={'outline-primary'} children={'Cancel'} className={'mt-2'} />
        </div>
        <div style={{ height: '79px', border: '2px solid red' }}>
          <span>Progress bar</span>
        </div>
      </section>

      {/* Items & Pricing dashboard*/}
      <section className={'mb-8'}>
        <h2 className={'text-center mb-7'}>Items & Pricing</h2>
        <Row>
          <div style={{ height: '180px', border: '2px solid red' }}></div>
        </Row>
      </section>

      {/* Buttons section */}
      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <PcButton variant={'outline-primary'} children={'Back'} onClick={handleBack} />
        <PcButton variant={'outline-primary'} children={'Download'} onClick={handleNext} />
      </section>
    </Container>
  )
}
