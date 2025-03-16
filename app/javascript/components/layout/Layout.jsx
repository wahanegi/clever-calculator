import React from 'react'
import { NavbarTop } from './NavbarTop'

export const Layout = ({children}) => {
  return (
    <div className={'d-flex flex-column min-vh-100'}>
      <header>
        <NavbarTop />
      </header>
      <main>{children}</main>
    </div>
  )
}
