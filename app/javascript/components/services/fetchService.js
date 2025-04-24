import { ENDPOINTS } from '../shared'
import { del, get, post, put } from './api/httpRequests'
import { extractNames } from '../utils'

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
  upsertUseFormData: async (customer) => {
    const formData = new FormData()
    const { first_name, last_name } = extractNames(customer.full_name)

    if (customer.logo_url) {
      const response = await fetch(customer.logo_url)

      if (response.ok) {
        const blob = await response.blob()
        formData.append('customer[logo]', blob)
      } else {
        throw new Error('Failed to fetch logo')
      }
    }
    formData.append('customer[company_name]', customer.company_name)
    formData.append('customer[first_name]', first_name)
    formData.append('customer[last_name]', last_name)
    formData.append('customer[position]', customer.position)
    formData.append('customer[email]', customer.email)
    formData.append('customer[address]', customer.address)
    formData.append('customer[notes]', customer.notes)

    return post(ENDPOINTS.CUSTOMERS_UPSERT, formData)
  },
}

export const fetchCategories = {
  index: async () => await get(ENDPOINTS.CATEGORIES),
}
