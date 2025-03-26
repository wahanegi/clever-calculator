import React from 'react'
import { Container, Nav, Navbar } from 'react-bootstrap'
import { CiLogout } from 'react-icons/ci'
import { ROUTES } from '../shared'
import { fetchAuthentication } from '../services/fetchService'

export const NavbarTop = () => {
  const handleLogout = async () => {
    try {
      await fetchAuthentication.logout()
      window.location.href = ROUTES.LOGIN
    } catch (error) {
      console.error('Error logging out:', error)
    }
  }
  return (
    <Navbar className={'bg-primary justify-content-between'}>
      <Container>
        <Navbar.Brand href={ROUTES.HOME} className={'text-white d-flex align-items-center gap-2'}>
          Price Calculator
        </Navbar.Brand>
        <Nav.Link onClick={handleLogout} href={ROUTES.HOME} className={'text-white'}>
          <span className={'me-2 text-decoration-underline'}>Logout</span>
          <CiLogout className={'pc-logout pc-rotate-180'} />
        </Nav.Link>
      </Container>
    </Navbar>
  )
}
