import { ENDPOINTS } from '../shared'
import { del, get, post, put } from './api/httpRequests'

export const fetchQuotes = {
  create: (data) => post(ENDPOINTS.QUOTES, data),
  update: (id, data) => put(`${ENDPOINTS.QUOTES}/${id}`, data),
  show: (id) => get(`${ENDPOINTS.QUOTES}/${id}`),
  last: () => get(ENDPOINTS.QUOTES_LAST),
}

export const fetchAuthentication = {
  logout: () => del(ENDPOINTS.LOGOUT),
}
