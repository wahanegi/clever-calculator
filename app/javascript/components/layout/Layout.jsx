import React, { useEffect, useState } from 'react'
import { Header } from './Header'
import { Outlet } from 'react-router-dom'
import { fetchSetting } from '../services'

export const Layout = () => {
  const [setting, setSetting] = useState(null)

  useEffect(() => {
    fetchSetting.show()
      .then((response) => {
        const { data: { attributes } } = response

        setSetting(attributes)
      })
  }, [])

  const backgroundImageStyle = setting?.app_background ? { backgroundImage: `url(${setting?.app_background})` } : {}

  return (
    <div className={'layout d-flex flex-column min-vh-100'} style={backgroundImageStyle}>
      <Header setting={setting} />
      <main>
        <Outlet />
      </main>
    </div>
  )
}
