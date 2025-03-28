function initializePasswordToggle() {
  const passwordField = document.getElementById('password-field')
  const togglePassword = document.getElementById('toggle-password')

  if (passwordField && togglePassword) {
    // Clone and replace to avoid event listener stacking
    const newTogglePassword = togglePassword.cloneNode(true)
    togglePassword.parentNode.replaceChild(newTogglePassword, togglePassword)

    // Reassign variables to the new elements
    const updatedTogglePassword = document.getElementById('toggle-password')
    const updatedEyeIcon = document.getElementById('eye-icon')

    updatedTogglePassword.addEventListener('click', function () {
      // Toggle password visibility
      const isPasswordHidden = passwordField.getAttribute('type') === 'password'
      passwordField.setAttribute('type', isPasswordHidden ? 'text' : 'password')

      // Toggle between show and hide icons
      const newIcon = isPasswordHidden ? 'eye_hide_icon.svg' : 'eye_show_icon.svg'
      updatedEyeIcon.src = `/assets/${newIcon}`
    })
  }
}

document.addEventListener('turbo:load', initializePasswordToggle)
document.addEventListener('turbo:render', initializePasswordToggle)
