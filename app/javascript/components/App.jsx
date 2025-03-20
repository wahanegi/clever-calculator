import React from 'react'
import { BrowserRouter as Router, Navigate, Route, Routes } from 'react-router-dom'
import { Layout } from './layout'
import { CustomerInfo, ItemsPricing } from './pages'
import { Examples } from './pages/Examples'
import { ROUTES } from './shared'

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path={ROUTES.LOGIN} element={null} />
        <Route path={ROUTES.HOME} element={<Navigate to={ROUTES.CUSTOMER_INFO} replace />} />
        <Route element={<Layout />}>
          <Route path={ROUTES.CUSTOMER_INFO} element={<CustomerInfo />} />
          <Route path={ROUTES.ITEM_PRICING} element={<ItemsPricing />} />
          <Route path={'*'} element={<Navigate to={ROUTES.CUSTOMER_INFO} replace />} />
          // TODO: path={'/examples'} will be deleted
          <Route path={'/examples'} element={<Examples />} />
        </Route>
      </Routes>
    </Router>
  )
}

export default App
