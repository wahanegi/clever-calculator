/**
 * Retrieves the CSRF token from the meta tag
 * @returns {string|null} The CSRF token or null if not found
 */
const getCsrfToken = () => document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')

/**
 * Performs a POST request with CSRF token and JSON body
 * @param {string} url - The endpoint URL
 * @param {Object} body - The request payload
 * @returns {Promise<Response>} The fetch response
 * @throws {Error} If the response is not OK
 */
const fetchWithConfig = async (url, body) => {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCsrfToken(),
    },
    body: JSON.stringify(body),
  })
  if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
  return response
}

/**
 * Extracts the quote item index from the form input name
 * Used to replace NEW_RECORD placeholder in rendered HTML
 * @param {HTMLElement} group - The quote item group element
 * @returns {string|undefined} The quote item index or undefined if not found
 */
const getQuoteItemIndex = (group) => {
  return group
    .querySelector('input[name^="quote[quote_items_attributes]"]')
    ?.name.match(/quote_items_attributes\]\[(\d+)\]/)?.[1]
}

/**
 * Centralized error handler for logging errors consistently
 * @param {string} message - The error message
 * @param {Error|null} error - The error object, if any
 * @param {Object} [context={}] - Additional context for debugging
 */
const handleError = (message, error = null, context = {}) => {
  console.error(`${message}:`, { error, ...context })
}
