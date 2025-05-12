import React, { useEffect, useState } from 'react'
import { Header } from './Header'
import { Outlet } from 'react-router-dom'
import { fetchSetting } from '../services'
import { LOCAL_STORAGE_KEYS } from '../shared'

export const Layout = () => {
  const [setting, setSetting] = useState(() => {
    const cashedSetting = localStorage.getItem(LOCAL_STORAGE_KEYS.setting)
    return cashedSetting ? JSON.parse(cashedSetting) : {}
  })

  useEffect(() => {
    fetchSetting.show()
      .then((response) => {
        const { data: { attributes } } = response
        const isSettingUpdated = attributes.logo !== setting.logo || attributes.app_background !== setting.app_background

        if (isSettingUpdated) {
          setSetting(attributes)
          localStorage.setItem(LOCAL_STORAGE_KEYS.setting, JSON.stringify(attributes))
        }
      })
  }, [])

  const backgroundImageStyle = setting?.app_background ? {
    backgroundImage: `url(${setting?.app_background})`,
    backgroundSize: '333px',
  } : {}

  return (
    <div className={'layout d-flex flex-column min-vh-100'} style={backgroundImageStyle}>
      <Header setting={setting} />
      <main>
        <Outlet />
      </main>
    </div>
  )
}
