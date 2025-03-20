import { instance } from './axiosInstance'

export const get = (url, config = {}) => {
  return instance.get(url, config)
}
export const post = (url, data, config = {}) => {
  return instance.post(url, data, config)
}
export const put = (url, data, config = {}) => {
  return instance.put(url, data, config)
}
export const patch = (url, data, config = {}) => {
  return instance.patch(url, data, config)
}
export const del = (url, config = {}) => {
  return instance.delete(url, {
    ...config,
    headers: {
      ...config.headers,
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content,
    },
  })
}
