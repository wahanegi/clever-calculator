import React from 'react'
import { PcButton } from '../ui'
import { useNavigate } from 'react-router-dom'
import { ROUTES } from '../shared'
import { Col, Container, Row } from 'react-bootstrap'

export const Home = () => {
  const navigate = useNavigate()
  const handleNext = () => {
    navigate(ROUTES.CUSTOMER_INFO)
  }

  return (
    <Container>
      <h1>Home (Login) Page</h1>
      <PcButton children={'Customer info'} onClick={handleNext} />
    </Container>
  )
}
