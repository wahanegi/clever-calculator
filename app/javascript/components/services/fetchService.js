import { ENDPOINTS } from '../shared'
import { get, del, post, put } from './api/httpRequests'

export const fetchQuotes = {
  create: (data) => post(ENDPOINTS.QUOTES, data),
  update: (id, data) => put(`${ENDPOINTS.QUOTES}/${id}`, data),
}

export const fetchAuthentication = {
  logout: () => del(ENDPOINTS.LOGOUT),
}

export const fetchCustomers = {
  index: () => get(ENDPOINTS.CUSTOMERS),
  upsert: (data) => post(ENDPOINTS.CUSTOMERS_UPSERT, data),
}
