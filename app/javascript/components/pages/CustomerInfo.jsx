import React from 'react'
import { Container } from 'react-bootstrap'
import { QuoteCreation, CustomerForm } from '../shared'
import { getCurrentStepId } from '../utils'
import { useAppHooks } from '../hooks'

export const CustomerInfo = () => {
  const { location } = useAppHooks()
  const currentStepId = getCurrentStepId(location.pathname)

  return (
    <Container className={'wrapper pt-16'}>
      <section className={'mx-8'}>
        <QuoteCreation currentStepId={currentStepId} isBtnShow={false} />
      </section>
      <section className={'mt-10 d-flex flex-column align-items-center'}>
        <CustomerForm />
      </section>
    </Container>
  )
}
