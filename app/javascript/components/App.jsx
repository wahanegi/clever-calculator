import React from 'react'
import { BrowserRouter as Router, Navigate, Route, Routes } from 'react-router-dom'
import { Layout } from './layout'
import { CustomerInfo, Home, ItemsPricing } from './pages'
import { Examples } from './pages/Examples'
import { ROUTES } from './shared'

const App = () => {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path={ROUTES.HOME} element={<Home />} />
          <Route path={ROUTES.CUSTOMER_INFO} element={<CustomerInfo />} />
          <Route path={ROUTES.ITEM_PRICING} element={<ItemsPricing />} />
          <Route path={'*'} element={<Navigate to={ROUTES.HOME} replace />} />
          // TODO: path={'/examples'} will be deleted
          <Route path={'/examples'} element={<Examples />} />
        </Routes>
      </Layout>
    </Router>
  )
}

export default App
