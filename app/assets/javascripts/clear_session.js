//= require active_admin_helpers

/**
 * Clears all tmp_params in the session
 * @param {Function} [callback] - Optional callback to execute after clearing
 * @param {Object} [body] - Optional request body
 */
const clearSession = async (callback, body = {}) => {
  const url = '/admin/items/clear_session'
  try {
    await fetchWithConfig(url, body)
    if (callback) callback()
  } catch (error) {
    console.error('Session clear failed:', error)
  }
}

// Helper to check if the current path is within the item form flow
const isInItemFormFlow = () => {
  return location.pathname.match(/^\/admin\/items\/(?:new|\d+\/edit)(\/.*)?$/)
}

document.addEventListener('DOMContentLoaded', () => {
  // Handle "New Item" link click (general and blank slate)
  document.querySelectorAll('a[href$="/admin/items/new"], .blank_slate a[href="/admin/items/new"]').forEach((link) => {
    link.addEventListener('click', (event) => {
      event.preventDefault()
      clearSession(() => {
        window.location.href = '/admin/items/new'
      })
    })
  })

  // Handle custom cancel button
  const cancelButton = document.querySelector('.custom-cancel-button')
  if (cancelButton) {
    cancelButton.addEventListener('click', () => {
      clearSession(
        () => { window.location.href = '/admin/items' },
        { force: true },
      )
    })
  }

  // Handle navigation away from item form via tabs
  document.querySelectorAll('#tabs a').forEach((link) => {
    if (!isInItemFormFlow() || !link.href.includes('/admin/items')) {
      link.addEventListener('click', (event) => {
        event.preventDefault()
        clearSession(
          () => { window.location.href = link.href },
          { force: true },
        )
      })
    }
  })

  // Tab switch or minimize
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'hidden' && !isInItemFormFlow()) {
      navigator.sendBeacon('/admin/items/clear_session', JSON.stringify({ force: true }))
    }
  })

  // Browser close / reload
  window.addEventListener('beforeunload', () => {
    if (!isInItemFormFlow()) {
      navigator.sendBeacon('/admin/items/clear_session', JSON.stringify({ force: true }))
    }
  })
})
