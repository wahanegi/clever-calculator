import axios from 'axios'

const BASE_URL = '/'
const instance = axios.create({
  baseURL: BASE_URL,
  withCredentials: true,
})

instance.interceptors.request.use((config) => {
  // Use interceptors.request to add the CSRF token to all requests
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

  if (csrfToken) {
    config.headers['X-CSRF-Token'] = csrfToken
  } else {
    console.error('CSRF token not found')
  }

  return config
})

export { instance }
