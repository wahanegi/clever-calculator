import React from 'react'
import { Container } from 'react-bootstrap'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'
import { PcButton } from '../ui'

export const Home = () => {
  const navigate = useNavigate()
  const handleNext = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container>
      <h1>Home (Login) Page</h1>
      <PcButton children={'Login'} onClick={handleNext} />
    </Container>
  )
}
