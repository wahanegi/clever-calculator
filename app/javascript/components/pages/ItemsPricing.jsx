import React from 'react'
import { PcButton } from '../ui'
import { Container } from 'react-bootstrap'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'

export const ItemsPricing = () => {
  const navigate = useNavigate()
  const handleNext = () => {
    navigate('/qq')
  }

  const handleBack = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container>
      <h1>Items Pricing Page</h1>
      <div className={'d-flex justify-content-center align-items-center gap-4'}>
        <PcButton variant={'outline-primary'} children={'Back'} onClick={handleBack} />
        <PcButton variant={'outline-primary'} children={'Next'} onClick={handleNext} />
      </div>
    </Container>
  )
}
