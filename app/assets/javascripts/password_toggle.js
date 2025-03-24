document.addEventListener('DOMContentLoaded', function () {
  const passwordField = document.getElementById('password-field')
  const togglePassword = document.getElementById('toggle-password')
  const eyeIcon = document.getElementById('eye-icon')

  if (passwordField && togglePassword && eyeIcon) {
    togglePassword.addEventListener('click', function () {
      // Toggle password visibility
      const isPasswordHidden = passwordField.getAttribute('type') === 'password'
      passwordField.setAttribute('type', isPasswordHidden ? 'text' : 'password')

      // Toggle between show and hide icons
      const newIcon = isPasswordHidden ? 'eye_hide_icon.svg' : 'eye_show_icon.svg'
      eyeIcon.src = `/assets/${newIcon}`
    })
  }
})
