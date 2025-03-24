import React from 'react'
import { Container, Row } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { fetchQuotes } from '../services'
import { ROUTES, STEPS } from '../shared'
import { PcButton } from '../ui'

export const ItemsPricing = () => {
  const { navigate, queryParams } = useAppHooks()
  const quoteId = queryParams.get('quote_id')

  const handleDownload = async () => {
    await fetchQuotes.update(quoteId, {
      quote: { step: STEPS.COMPLETED },
    })
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
          <PcButton variant={'outline-primary'} children={'Reset'} className={'mt-2'} />
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
        <PcButton variant={'outline-primary'} children={'Download'} onClick={handleDownload} />
      </section>
    </Container>
  )
}
