import { instance } from './axiosInstance'

// Function to make HTTP requests & using try/catch for error handling
const request = async (method = 'GET', url = '', data = {}, config = {}) => {
  try {
    const response = await instance({ method, url, data, ...config })
    return response?.data
  } catch (err) {
    console.error(`API Error (${method} ${url}):`, err.response || err)
    throw err
  }
}

// HTTP requests functions
export const get = (url, config) => request(url, config)
export const post = (url, data, config) => request('POST', url, data, config)
export const put = (url, data, config) => request('PUT', url, data, config)
export const patch = (url, data, config) => request('PATCH', url, data, config)
export const del = (url, config) => request('DELETE', url, config)
