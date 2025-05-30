/**
 * Handles the "Remove Item" button click, marking persisted items for destruction or removing new items.
 */
const handleRemoveItem = () => {
  document.addEventListener('click', function (e) {
    const removeBtn = e.target.closest('.has_many_remove')
    if (!removeBtn) return

    e.preventDefault()
    e.stopImmediatePropagation() // Prevent Active Admin's default handler

    const fieldset = removeBtn.closest('.has_many_fields')
    if (!fieldset) return

    const form = document.querySelector('form.quote-form')
    if (!form) return

    const destroyField = fieldset.querySelector('input.destroy-field')
    const idField = fieldset.querySelector('input[name*="[id]"]')
    const destroyName = destroyField?.getAttribute('name') || ''

    const isPersistedRecord = /\[\d+\]/.test(destroyName)

    if (destroyField && idField && isPersistedRecord) {
      destroyField.value = '1'

      // Create or get hidden container
      let hiddenContainer = form.querySelector('#hidden-quote-items')
      if (!hiddenContainer) {
        hiddenContainer = document.createElement('div')
        hiddenContainer.id = 'hidden-quote-items'
        hiddenContainer.style.display = 'none'
        form.appendChild(hiddenContainer)
      }

      // Move fieldset to hidden container
      fieldset.style.display = 'none'
      hiddenContainer.appendChild(fieldset)
    } else {
      fieldset.remove()
    }
  })
}
