import React from 'react'
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import { Layout } from './layout'
import { Home } from './pages'
import { ROUTES } from './shared'

const App = () => {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path={ROUTES.HOME} element={<Home />} />
        </Routes>
      </Layout>
    </Router>
  )
}

export default App 
