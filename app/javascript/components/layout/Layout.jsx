import React from 'react'
import { NavbarTop } from './NavbarTop'
import { Outlet } from 'react-router-dom'

export const Layout = () => {
  return (
    <div className={'d-flex flex-column min-vh-100'}>
      <header>
        <NavbarTop />
      </header>
      <main>
        <Outlet />
      </main>
    </div>
  )
}
