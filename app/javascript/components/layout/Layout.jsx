import React from 'react'
import { Header } from './Header'
import { Outlet } from 'react-router-dom'

export const Layout = () => {
  return (
    <div className={'d-flex flex-column min-vh-100'}>
      <Header />
      <main>
        <Outlet />
      </main>
    </div>
  )
}
