import React from 'react'
import { Container } from 'react-bootstrap'
import { QuoteCreation, CustomerForm } from '../shared'
import { getCurrentStepId } from '../utils'
import { useAppHooks } from '../hooks'

export const CustomerInfo = () => {
  const { location } = useAppHooks()
  const currentStepId = getCurrentStepId(location.pathname)

  // const handleNext = async () => {
  //   //TODO Hardcode customer_id for now (replace with real logic later)
  //   const customerId = 3
  //   const { data } = await fetchQuotes.create({
  //     quote: {
  //       customer_id: customerId,
  //       total_price: 0,
  //       step: STEPS.ITEM_PRICING,
  //     },
  //   })
  //
  //   navigate(`${ROUTES.ITEM_PRICING}?quote_id=${data.id}`)
  // }

  // Remove it when you need to create a quote
  const handleNext = () => {
    navigate(ROUTES.ITEM_PRICING)
  }

  return (
    <Container className={'wrapper'}>
      <QuoteCreation currentStepId={currentStepId} isBtnShow={false} />
      <section className={'mt-7 d-flex flex-column gap-4 align-items-center'}>
        <CustomerForm />
      </section>
    </Container>
  )
}
