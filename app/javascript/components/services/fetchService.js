import { ENDPOINTS } from '../shared'
import { del, get, patch, post, put } from './api/httpRequests'
import { extractNames } from '../utils'

export const fetchQuotes = {
  create: (data) => post(ENDPOINTS.QUOTES, data),
  update: (id, data) => put(`${ENDPOINTS.QUOTES}/${id}`, data),
}

export const fetchAuthentication = {
  logout: () => del(ENDPOINTS.LOGOUT),
}

export const fetchCustomers = {
  show: () => get(ENDPOINTS.SETTING),
  index: () => get(ENDPOINTS.CUSTOMERS),
  upsert: (data) => post(ENDPOINTS.CUSTOMERS_UPSERT, data),
  upsertUseFormData: async (customer) => {
    const formData = new FormData()
    const { first_name, last_name } = extractNames(customer.full_name)

    if (customer.logo_url) {
      const response = await fetch(customer.logo_url)

      if (response.ok) {
        const contentType = response.headers.get('Content-Type')
        const blob = await response.blob()
        const fileName = `logo.${contentType.split('/')[1] || 'png'}`

        formData.append('customer[logo]', blob, fileName)
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

export const fetchSetting = {
  show: () => get(ENDPOINTS.SETTING),
}

export const fetchCategories = {
  index: async () => await get(ENDPOINTS.CATEGORIES),
}

export const fetchItems = {
  uncategorized: async () => await get(ENDPOINTS.UNCATEGORIZED_ITEMS),
}

export const fetchQuoteItems = {
  createFromItem: async (quoteId, itemId) => await post(`${ENDPOINTS.QUOTES}/${quoteId}/quote_items/create_from_item`, { quote_item: { item_id: itemId } }),
  createFromCategory: async (quoteId, categoryId) => await post(`${ENDPOINTS.QUOTES}/${quoteId}/quote_items/create_from_category`, { quote_item: { category_id: categoryId } }),
  deleteSelected: async (quoteId, quoteItemIds) => await del(`${ENDPOINTS.QUOTES}/${quoteId}/quote_items/destroy_selected`, { quote_item_ids: quoteItemIds }),
  index: async (quoteId) => await get(`${ENDPOINTS.QUOTES}/${quoteId}/quote_items`),
  update: async (quoteId, quoteItemId, data) => await patch(`${ENDPOINTS.QUOTES}/${quoteId}/quote_items/${quoteItemId}`, data),
}

export const fetchSelectableOptions = {
  index: async () => await get(ENDPOINTS.SELECTABLE_OPTIONS),
}
