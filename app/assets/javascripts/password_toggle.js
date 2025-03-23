document.addEventListener('DOMContentLoaded', function () {
  const passwordField = document.getElementById('password-field')
  const togglePassword = document.getElementById('eye-icon')

  if (passwordField && togglePassword) {
    togglePassword.addEventListener('click', function () {
      // Toggle the type attribute
      const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password'
      passwordField.setAttribute('type', type)

      // Toggle the icon's appearance
      togglePassword.classList.toggle('password-visible')
    })
  }
})
