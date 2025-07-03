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
        const isSettingUpdated = attributes.logo_light_background !== setting.logo_light_background || attributes.logo_dark_background !== setting.logo_dark_background

        if (isSettingUpdated) {
          setSetting(attributes)
          localStorage.setItem(LOCAL_STORAGE_KEYS.setting, JSON.stringify(attributes))
        }
      })
  }, [])

  return (
    <div className={'layout d-flex flex-column min-vh-100'}>
      <Header setting={setting} />
      <main>
        <Outlet />
      </main>
    </div>
  )
}
