import React from 'react'
import { Nav, Navbar } from 'react-bootstrap'
import { CiLogout } from 'react-icons/ci'
import { IMAGE_ASSETS, ROUTES } from '../shared'
import { fetchAuthentication } from '../services/fetchService'

export const Header = () => {
  const handleLogout = async () => {
    try {
      await fetchAuthentication.logout()
      window.location.href = ROUTES.LOGIN
    } catch (error) {
      console.error('Error logging out:', error)
    }
  }

  return <header className={'pc-header bg-primary'}>
    <Navbar className={'justify-content-between'}>
      <Navbar.Brand href={ROUTES.HOME} className={'ms-1 ms-xxl-15 ms-xl-15 ms-lg-10 ms-md-2'}>
        <img src={IMAGE_ASSETS.CLOVERPOP_LOGO} className={'pc-header-logo'} alt={'Cloverpop'} />
      </Navbar.Brand>
      <Nav.Link onClick={handleLogout} href={ROUTES.HOME} className={'me-1 me-xxl-14 me-xl-14 me-lg-10 me-md-2 text-white'}>
        <span className={'me-2 text-decoration-underline'}>Logout</span>
        <CiLogout className={'pc-logout pc-rotate-180'} />
      </Nav.Link>
    </Navbar>
  </header>
}
