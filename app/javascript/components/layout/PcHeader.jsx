import React from 'react'
import { Nav, Navbar } from 'react-bootstrap'
import { CiLogout } from 'react-icons/ci'
import { IMAGE_ASSETS, ROUTES } from '../shared'
import { fetchAuthentication } from '../services/fetchService'

export const PcHeader = () => {
  const handleLogout = async () => {
    try {
      await fetchAuthentication.logout()
      window.location.href = ROUTES.LOGIN
    } catch (error) {
      console.error('Error logging out:', error)
    }
  }

  return <header className={'pc-header bg-primary'}>
    <Navbar className={'justify-content-between align-items-center h-100'}>
      <Navbar.Brand href={ROUTES.HOME} className={'ms-1 ms-xxl-15 ms-xl-15 ms-lg-10 ms-md-2'}>
        <div className={'pc-header-logo d-flex'}>
          <img src={IMAGE_ASSETS.LOGO} className={'pc-header-logo-image'} alt={'Logo'} />
          <div className={'pc-header-logo-text d-flex flex-column'}>
            <span className={'fw-bold text-uppercase text-black'}>This is</span>
            <span className={'fw-bolder text-uppercase text-black'}>My logo</span>
          </div>
        </div>
      </Navbar.Brand>
      <Nav.Link onClick={handleLogout} href={ROUTES.HOME} className={'me-1 me-xxl-14 me-xl-14 me-lg-10 me-md-2 text-white'}>
        <span className={'me-2 text-decoration-underline'}>Logout</span>
        <CiLogout className={'pc-logout pc-rotate-180'} />
      </Nav.Link>
    </Navbar>
  </header>
}
