import React from 'react'
import { PcHeader } from './PcHeader'
import { Outlet } from 'react-router-dom'

export const Layout = () => {
  return (
    <div className={'d-flex flex-column min-vh-100'}>
      <PcHeader />
      <main>
        <Outlet />
      </main>
    </div>
  )
}
