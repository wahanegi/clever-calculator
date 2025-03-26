import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'

document.addEventListener('turbo:load', () => {
  const appElement = document.querySelector('#app')

  if (appElement) {
    const root = createRoot(appElement)
    root.render(<App />)
  } else {
    console.error('The element #app was not found. Ensure that your HTML document includes <div id=\'app\'></div>.')
  }
})

