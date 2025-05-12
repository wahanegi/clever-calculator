export const normalizeName = (name) =>
  name?.replace(/\s+/g, ' ').trim().toLowerCase() || ''