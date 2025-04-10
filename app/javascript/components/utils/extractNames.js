export const extractNames = (fullName = '') => {
  const [first, ...rest] = fullName.trim().split(' ')
  return {
    first_name: first || '',
    last_name: rest.join(' ') || '',
  }
}
