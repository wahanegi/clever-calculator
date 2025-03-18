import React from 'react'
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import { Layout } from './layout'
import { CustomerInfo, Home, ItemsPricing } from './pages'
import { ROUTES } from './shared'
import { Examples } from './pages/Examples'

const App = () => {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path={ROUTES.HOME} element={<Home />} />
          <Route path={ROUTES.CUSTOMER_INFO} element={<CustomerInfo />} />
          <Route path={ROUTES.ITEM_PRICING} element={<ItemsPricing />} />
          <Route path={'/examples'} element={<Examples />} /> // TODO: will be deleted
        </Routes>
      </Layout>
    </Router>
  )
}

export default App
