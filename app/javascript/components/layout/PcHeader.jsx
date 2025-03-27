import React from 'react'
import { Nav, Navbar } from 'react-bootstrap'
import { ROUTES } from '../shared'
import { fetchAuthentication } from '../services'
import { PcIcon } from '../ui'

export const PcHeader = () => {

  const Logo = () =>
    <Navbar.Brand href={ROUTES.HOME}
                  className={'ms-1 ms-xxl-15 ms-xl-15 ms-lg-10 ms-md-2'}>
      <div className={'pc-header-logo d-flex'}>
        <PcIcon name={'logo'} className={'pc-header-logo-separator'} alt={'Logo'} />
        <div className={'pc-header-logo-text d-flex flex-column'}>
          <span className={'fw-bold text-uppercase text-black'}>This is</span>
          <span className={'fw-bolder text-uppercase text-black'}>My logo</span>
        </div>
      </div>
    </Navbar.Brand>

  const UserProfile = () => {
    const handleLogout = async () => {
      try {
        await fetchAuthentication.logout()
        window.location.href = ROUTES.LOGIN
      } catch (error) {
        console.error('Error logging out:', error)
      }
    }

    return <Nav.Link onClick={handleLogout}
                     href={ROUTES.HOME}
                     className={'me-1 me-xxl-14 me-xl-14 me-lg-10 me-md-2 text-white'}>
      <span className={'me-2 fw-normal text-decoration-underline'}>Logout</span>
      <PcIcon name={'logout'} alt={'Logout'} />
    </Nav.Link>
  }

  return <header className={'pc-header bg-primary'}>
    <Navbar className={'justify-content-between align-items-center h-100'}>
      <Logo />
      <UserProfile />
    </Navbar>
  </header>
}
