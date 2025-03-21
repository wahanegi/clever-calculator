import React from 'react'
import { BrowserRouter as Router, Navigate, Route, Routes } from 'react-router-dom'
import { Layout } from './layout'
import { CustomerInfo, ItemsPricing } from './pages'
import { ROUTES } from './shared'

const App = () => {
  return (
    <Router>
      <Routes>
        <Route element={<Layout />}>
          <Route path={ROUTES.CUSTOMER_INFO} element={<CustomerInfo />} />
          <Route path={ROUTES.ITEM_PRICING} element={<ItemsPricing />} />
          <Route path={'*'} element={<Navigate to={ROUTES.CUSTOMER_INFO} replace />} />
        </Route>
        <Route path={ROUTES.LOGIN} element={<Navigate to={ROUTES.LOGIN} replace />} />
      </Routes>
    </Router>
  )
}

export default App
