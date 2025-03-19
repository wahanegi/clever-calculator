import axios from 'axios'

const BASE_URL = '/'

// Getting CSRF-token and put it for all requests
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

export const instance = axios.create({
  baseURL: BASE_URL,
  withCredentials: true,
})
