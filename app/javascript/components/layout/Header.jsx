import React from 'react'
import { Button, Navbar } from 'react-bootstrap'
import { ROUTES } from '../shared'
import { fetchAuthentication } from '../services'
import { PcIcon } from '../ui'

const Logo = ({ setting }) => (
  <Navbar.Brand className={'ms-1 ms-xxl-27 ms-xl-27 ms-lg-10 ms-md-2'}>
    {setting?.logo_dark_background
      ? (<img src={setting.logo_dark_background} className={'header-logo object-fit-contain'} alt={'Logo'} />)
      : (<PcIcon name={'logo'} className={'header-logo pc-icon-logo'} alt={'Logo'} />)}
  </Navbar.Brand>
)

const UserProfile = () => {
  const handleLogout = async () => {
    try {
      await fetchAuthentication.logout()
      window.location.href = ROUTES.LOGIN
    } catch (error) {
      console.error('Error logging out:', error)
    }
  }

  return (
    <Button
      className={'me-1 me-xxl-25 me-xl-25 me-lg-15 me-md-2 header-logout'}
      onClick={handleLogout}>
      <span className={'text-white me-2 fw-normal text-decoration-underline'}>Logout</span>
      <PcIcon name={'logout'} alt={'Logout'} className={'pc-icon-logout'} />
    </Button>
  )
}

export const Header = ({ setting }) => (
  <header className={'header bg-primary'}>
    <Navbar className={'justify-content-between align-items-center h-100'}>
      <Logo setting={setting} />
      <UserProfile />
    </Navbar>
  </header>
)
