import React, { useEffect, useState } from 'react'
import { Nav, Navbar } from 'react-bootstrap'
import { ROUTES } from '../shared'
import { fetchAuthentication, fetchSetting } from '../services'
import { PcIcon } from '../ui'

export const Header = ({ setting }) => {
  const Logo = () =>
    <Navbar.Brand className={'ms-1 ms-xxl-22 ms-xl-22 ms-lg-10 ms-md-2'}>
      {setting?.logo ?
        (<img src={setting.logo} className={'header-logo object-fit-contain'} alt={'Logo'} />)
        : (<div className={'header-logo d-flex'}>
          <PcIcon name={'logo'} className={'pc-icon-logo header-logo-separator'} alt={'Logo'} />
          <div className={'header-logo-text d-flex flex-column'}>
            <span className={'fw-bold text-uppercase text-black'}>This is</span>
            <span className={'fw-bolder text-uppercase text-black'}>My logo</span>
          </div>
        </div>)}
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

    return <Nav.Link onClick={handleLogout} className={'me-1 me-xxl-20 me-xl-20 me-lg-10 me-md-2 header-logout'}>
      <span className={'text-white me-2 fw-normal text-decoration-underline'}>Logout</span>
      <PcIcon name={'logout'} alt={'Logout'} className={'pc-icon-logout'} />
    </Nav.Link>
  }

  return <header className={'header bg-primary'}>
    <Navbar className={'justify-content-between align-items-center h-100'}>
      <Logo />
      <UserProfile />
    </Navbar>
  </header>
}
