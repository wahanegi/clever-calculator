import React from 'react'
import { Container } from 'react-bootstrap'
import { QuoteCreation, CustomerForm } from '../shared'
import { getCurrentStepId } from '../utils'
import { useAppHooks } from '../hooks'

export const CustomerInfo = () => {
  const { location } = useAppHooks()
  const currentStepId = getCurrentStepId(location.pathname)

  return (
    <Container className={'wrapper'}>
      <QuoteCreation currentStepId={currentStepId} isBtnShow={false} />
      <section className={'mt-7 d-flex flex-column gap-4 align-items-center'}>
        <CustomerForm />
      </section>
    </Container>
  )
}
