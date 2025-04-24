export const getRemovedCategory = (previous, current) => {
  return previous.find(prevItem =>
    !current.some(currItem => currItem.id === prevItem.id)
  ) || null
}