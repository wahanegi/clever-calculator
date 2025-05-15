/**
 * Manages note fields in Active Admin has_many containers.
 * Handles cleaning empty notes, toggling add buttons, and setting up event listeners.
 */

const NOTE_SELECTORS = {
  container: '.has_many_container.note',
  fields: '.has_many_fields',
  textarea: 'textarea.note-textarea',
  addButton: '.has_many_add',
  removeButton: '.has_many_remove',
}

/**
 * Cleans empty note fields in a has_many container and toggles the add button.
 * @param {HTMLElement} container - The has_many container element.
 * @param {string} [textareaSelector=NOTE_SELECTORS.textarea] - Selector for the textarea.
 */
const cleanNoteFields = (container, textareaSelector = NOTE_SELECTORS.textarea) => {
  // Skip cleaning if the form has validation errors
  const form = container.closest('form')
  if (form && form.querySelector('.errors, .error')) {
    console.debug('Skipping cleanNoteFields due to form errors')
    return
  }

  const noteFields = container.querySelectorAll(NOTE_SELECTORS.fields)
  noteFields.forEach((field) => {
    const textarea = field.querySelector(textareaSelector)
    const hasError = field.querySelector('.error') || field.classList.contains('error')
    if (!textarea || (!textarea.value.trim() && !hasError)) {
      field.remove()
    }
  })
  const addButton = container.querySelector(NOTE_SELECTORS.addButton)
  if (addButton) toggleAddNoteButton(addButton, container)
}

/**
 * Toggles the visibility of the add button based on note field presence.
 * @param {HTMLElement} addButton - The add button element.
 * @param {HTMLElement} container - The has_many container element.
 */
const toggleAddNoteButton = (addButton, container) => {
  const noteFields = container.querySelectorAll(NOTE_SELECTORS.fields)
  addButton.style.display = noteFields.length >= 1 ? 'none' : 'inline-block'
}

/**
 * Sets up event listeners for add/remove buttons in a note container.
 * @param {HTMLElement} container - The has_many container element.
 */
const setupNoteContainer = (container) => {
  const addButton = container.querySelector(NOTE_SELECTORS.addButton)
  if (!addButton) {
    console.warn('Add button not found in note container:', container)
    return
  }

  addButton.addEventListener('click', () => {
    addButton.style.display = 'none'
    setTimeout(() => toggleAddNoteButton(addButton, container), 0)
  })

  container.addEventListener('click', (event) => {
    if (event.target.classList.contains(NOTE_SELECTORS.removeButton.replace('.', ''))) {
      setTimeout(() => toggleAddNoteButton(addButton, container), 0)
    }
  })
}

/**
 * Initializes note management for all note containers and watches for dynamic additions.
 * @param {HTMLElement} [root=document] - The root element to watch for note containers.
 */
const initializeNoteManagement = (root = document) => {
  // Initialize existing note containers
  root.querySelectorAll(NOTE_SELECTORS.container).forEach((container) => {
    setupNoteContainer(container)
    cleanNoteFields(container)
  })

  // Watch for dynamically added note containers
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.addedNodes.length) {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === 1) {
            node.querySelectorAll(NOTE_SELECTORS.container).forEach((container) => {
              setupNoteContainer(container)
              cleanNoteFields(container)
            })
          }
        })
      }
    })
  })

  observer.observe(root, { childList: true, subtree: true })
}

// Initialize on DOM load
document.addEventListener('DOMContentLoaded', () => {
  initializeNoteManagement()
})
