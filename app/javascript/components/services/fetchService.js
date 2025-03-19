import { ENDPOINTS } from '../shared'
import { get, patch, post, put } from './api/httpRequests'

export const fetchQuotes = {
  getAll: () => get(ENDPOINTS.QUOTES),
  getById: (id) => get(`${ENDPOINTS.QUOTES}/${id}`),
  delete: (id) => del(`${ENDPOINTS.QUOTES}/${id}`),
  create: (data) => post(ENDPOINTS.QUOTES, data),
  update: (id, data) => put(`${ENDPOINTS.QUOTES}/${id}`, data),
  partialUpdate: (id, data) => patch(`${ENDPOINTS.QUOTES}/${id}`, data),
}
