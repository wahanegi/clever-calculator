//= require active_admin/base
//= require formula_builder
//= require new_parameter
//= require quotes_admin

// clear new item session
document.addEventListener('DOMContentLoaded', function () {
  const newItemLink = document.querySelector('a[href$="/admin/items/new"]')

  if (newItemLink) {
    newItemLink.addEventListener('click', function (event) {
      event.preventDefault()

      fetch('/admin/items/new/clear_session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      }).then((response) => {
        if (response.ok) {
          window.location.href = '/admin/items/new'
        } else {
          alert('❌ Session clear failed')
        }
      })
    })
  }
})

document.addEventListener('DOMContentLoaded', function () {
  const cancelButton = document.querySelector('.custom-cancel-button')

  if (cancelButton) {
    cancelButton.addEventListener('click', function () {
      const itemId = cancelButton.dataset.itemId

      fetch(`/admin/items/${itemId}/clear_session`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      }).then(() => {
        window.location.href = '/admin/items'
      })
    })
  }
})

// Dropdown functionality for Categories and Items in Quotes
document.addEventListener('DOMContentLoaded', () => {
  window.dropdownUpdateFunctions = window.dropdownUpdateFunctions || []

  document.querySelectorAll('.dropdown-wrapper').forEach((wrapper) => {
    const toggle = wrapper.querySelector('.dropdown-toggle')
    const content = wrapper.querySelector('.dropdown-content')
    const selectedCategoryDisplay = wrapper.querySelector('.selected-category-names')
    const selectedItemDisplay = wrapper.querySelector('.selected-item-names')

    const checkboxClass = selectedCategoryDisplay ? 'category-checkbox' : 'items-checkbox'
    const selectedDisplay = selectedCategoryDisplay || selectedItemDisplay
    const noSelectionText = selectedCategoryDisplay ? 'No categories selected' : 'No items selected'

    const updateSelectedNames = () => {
      const checkedBoxes = wrapper.querySelectorAll(`input.${checkboxClass}[type="checkbox"]:checked`)
      const selectedNames = Array.from(checkedBoxes)
        .map((cb) => {
          const label = wrapper.querySelector(`label[for="${cb.id}"]`)
          return label ? label.textContent.trim() : ''
        })
        .filter((name) => name.length > 0)

      if (selectedDisplay) {
        selectedDisplay.textContent = selectedNames.length > 0 ? selectedNames.join(', ') : noSelectionText
      }
    }

    if (toggle && content) {
      // Toggle dropdown
      toggle.addEventListener('click', (e) => {
        e.stopPropagation()
        wrapper.classList.toggle('open')
      })

      // Close dropdown on outside click
      document.addEventListener('click', (e) => {
        if (!wrapper.contains(e.target)) {
          wrapper.classList.remove('open')
        }
      })

      const checkboxes = wrapper.querySelectorAll(`input.${checkboxClass}[type="checkbox"]`)
      checkboxes.forEach((cb) => {
        cb.addEventListener('change', () => {
          updateSelectedNames()
        })
      })

      // Store the update function globally
      window.dropdownUpdateFunctions.push(updateSelectedNames)

      // Initial update
      updateSelectedNames()
    }
  })
})
