import React from 'react'
import { PcButton } from '../ui'
import { Container } from 'react-bootstrap'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'

export const CustomerInfo = () => {
  const navigate = useNavigate()
  const handleNext = () => {
    navigate(ROUTES.ITEM_PRICING)
  }

  return (
    <Container>
      <h1>Customer Info Page</h1>
      <div className={'d-flex justify-content-center align-items-center gap-4'}>
        <PcButton children={'Next'} onClick={handleNext} />
      </div>
    </Container>
  )
}
