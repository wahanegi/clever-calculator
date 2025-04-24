import { ENDPOINTS } from '../shared'
import { del, post, put, get } from './api/httpRequests'

export const fetchQuotes = {
  create: (data) => post(ENDPOINTS.QUOTES, data),
  update: (id, data) => put(`${ENDPOINTS.QUOTES}/${id}`, data),
}

export const fetchAuthentication = {
  logout: () => del(ENDPOINTS.LOGOUT),
}

export const fetchSetting = {
  show: () => get(ENDPOINTS.SETTING),
}
