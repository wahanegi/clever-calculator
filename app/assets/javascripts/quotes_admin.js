document.addEventListener('DOMContentLoaded', () => {
  // Main container for quote items
  const container = document.querySelector('.has_many_container.quote_items')
  if (!container) return

  // DOM selectors for commonly used elements
  const selectors = {
    heading: 'h3',
    addButton: '.has_many_container.quote_items > a.has_many_add',
    itemGroups: '.has_many_container.quote_items fieldset.has_many_fields:not(.quote-item-note-wrapper)',
    itemId: 'input.item-id-field',
    itemName: 'span.item-name-field',
    category: 'span.category-name-field',
    discount: "input[id$='_discount']",
    price: "input[id$='_price']",
    finalPrice: "input[id$='_final_price']",
    preview: '.quote-parameters-preview',
    categoryCheckboxes: "input[name='quote[category_ids][]']",
    itemCheckboxes: "input[name='quote[item_ids][]']",
    loadButton: '#load-items-button',
  }

  // Utility Functions
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
   * Updates form fields for a quote item group
   * @param {HTMLElement} group - The quote item group element
   * @param {Object} itemData - Item data containing id, name, category, and discount
   * @param {boolean} [isNewItem=false] - Whether this is a new item (resets price fields)
   */
  const updateItemFields = (group, itemData, isNewItem = false) => {
    const fields = {
      itemId: group.querySelector(selectors.itemId),
      itemName: group.querySelector(selectors.itemName),
      category: group.querySelector(selectors.category),
      discount: group.querySelector(selectors.discount),
      price: isNewItem ? group.querySelector(selectors.price) : null,
      finalPrice: isNewItem ? group.querySelector(selectors.finalPrice) : null,
    }

    if (fields.itemId) fields.itemId.value = itemData.item_id
    if (fields.itemName) {
      fields.itemName.textContent = itemData.item_name
      fields.itemName.dataset.item_name = itemData.item_name
    }
    if (fields.category) fields.category.textContent = itemData.category_name || 'Other'
    if (fields.discount) fields.discount.value = itemData.discount || '0'
    if (fields.price) fields.price.value = '0'
    if (fields.finalPrice) fields.finalPrice.value = '0'
  }

  /**
   * Fetches and renders quote item parameters with existing values
   * @param {HTMLElement} group - The quote item group element
   * @param {string} itemId - The ID of the item
   */
  const renderQuoteParameters = async (group, itemId) => {
    const previewContainer = group.querySelector(selectors.preview)
    if (!previewContainer) {
      console.error('Preview container not found for group:', group)
      return
    }

    const quoteItemIndex = getQuoteItemIndex(group)
    if (!quoteItemIndex) {
      console.error('Quote item index not found for group:', group)
      return
    }

    // Gather existing values from hidden fields
    const openParamInputs = group.querySelectorAll(
      `input[name^="quote[quote_items_attributes][${quoteItemIndex}][open_param_values]"]`,
    )
    const selectParamInputs = group.querySelectorAll(
      `input[name^="quote[quote_items_attributes][${quoteItemIndex}][select_param_values]"]`,
    )

    const open_param_values = {}
    const select_param_values = {}

    openParamInputs.forEach((input) => {
      const paramName = input.dataset.paramName || input.name.match(/\[open_param_values\]\[(.+)\]/)?.[1]
      if (paramName) {
        open_param_values[paramName] = input.value
      } else {
        console.warn('No param name found for open param input:', input)
      }
    })

    selectParamInputs.forEach((input) => {
      const paramName = input.dataset.paramName || input.name.match(/\[select_param_values\]\[(.+)\]/)?.[1]
      if (paramName) {
        select_param_values[paramName] = input.value
      } else {
        console.warn('No param name found for select param input:', input)
      }
    })

    try {
      const response = await fetchWithConfig('/admin/quotes/render_quote_item_parameters', {
        item_id: itemId,
        open_param_values,
        select_param_values,
      })
      const html = await response.text()
      previewContainer.innerHTML = html.replace(/NEW_RECORD/g, quoteItemIndex)
    } catch (error) {
      console.error('Error rendering quote parameters:', error)
    }
  }

  /**
   * Adds a new quote item to the form
   * @param {Object} itemData - Item data containing id, name, category, and discount
   * @param {boolean} [isDuplicate=false] - Whether this is a duplicate item
   */
  const addNewQuoteItem = async (itemData, isDuplicate = false) => {
    const addButton = container.querySelector(selectors.addButton)
    const template = addButton.dataset.html
    const existingIndices = Array.from(container.querySelectorAll('input[name^="quote[quote_items_attributes]"]'))
      .map((input) => parseInt(input.name.match(/quote_items_attributes\]\[(\d+)\]/)?.[1]))
      .filter((index) => !isNaN(index))
    const newIndex = existingIndices.length ? Math.max(...existingIndices) + 1 : 0

    const newItemHtml = template.replace(/NEW_QUOTE_ITEM_RECORD/g, newIndex)
    const tempDiv = document.createElement('div')
    tempDiv.innerHTML = newItemHtml
    const newItemGroup = tempDiv.firstElementChild
    let itemsContainer = container.querySelector('ol')
    if (!itemsContainer) {
      itemsContainer = document.createElement('ol')
      container.insertBefore(itemsContainer, addButton)
    }

    itemsContainer.appendChild(newItemGroup)

    const noteContainer = newItemGroup.querySelector('.has_many_container.note')
    if (noteContainer) {
      const noteFields = noteContainer.querySelectorAll('.has_many_fields')
      noteFields.forEach((field) => field.remove())
      const noteAddButton = noteContainer.querySelector('.has_many_add')
      if (noteAddButton) noteAddButton.style.display = 'inline-block'
    }
    updateItemFields(newItemGroup, itemData, isDuplicate)
    if (itemData.item_id) {
      await renderQuoteParameters(newItemGroup, itemData.item_id)
    }
  }

  // Initialize existing quote items
  const initializeQuoteItems = (retryCount = 0) => {
    const maxRetries = 3
    const itemGroups = document.querySelectorAll(selectors.itemGroups)

    if (itemGroups.length === 0 && retryCount < maxRetries) {
      setTimeout(() => initializeQuoteItems(retryCount + 1), 500)
      return
    }
    itemGroups.forEach(async (group, index) => {
      const itemId = group.querySelector(selectors.itemId)?.value
      if (itemId) {
        // Clean notes for existing items
        const noteContainer = group.querySelector('.has_many_container.note')
        if (noteContainer) {
          const noteFields = noteContainer.querySelectorAll('.has_many_fields')
          noteFields.forEach((field) => {
            const textarea = field.querySelector('textarea.note-textarea')
            if (!textarea || !textarea.value.trim()) {
              field.remove()
            }
          })
          const noteAddButton = noteContainer.querySelector('.has_many_add')
          if (noteAddButton) noteAddButton.style.display = 'inline-block'
        }
        await renderQuoteParameters(group, itemId)
      } else {
        console.warn(
          'No itemId found for QuoteItem, index:',
          index,
          'group:',
          group.outerHTML.substring(0, 200) + '...',
        )
      }
    })
  }

  // Ensure DOM is ready
  setTimeout(() => initializeQuoteItems(), 500)

  // Initialization
  // Show heading if quote items exist on page load
  const heading = container.querySelector(selectors.heading)
  if (container.querySelectorAll(selectors.itemGroups).length > 0 && heading) {
    heading.style.display = 'block'
  }

  // Event Handlers
  // Handle clicking the "Load Items" button
  const loadItemsButton = document.querySelector(selectors.loadButton)
  if (loadItemsButton) {
    loadItemsButton.addEventListener('click', async () => {
      const selectedCategories = Array.from(document.querySelectorAll(`${selectors.categoryCheckboxes}:checked`)).map(
        (cb) => cb.value,
      )
      const selectedItems = Array.from(document.querySelectorAll(`${selectors.itemCheckboxes}:checked`)).map(
        (cb) => cb.value,
      )

      if (!selectedCategories.length && !selectedItems.length) {
        alert('Please select at least one category or item.')
        return
      }

      try {
        const response = await fetchWithConfig('/admin/quotes/load_items', {
          category_ids: selectedCategories,
          item_ids: selectedItems,
        })
        const items = await response.json()

        // Sort items by category name for consistent display
        items.sort((a, b) => {
          const catA = a.category_name?.toLowerCase() || 'other'
          const catB = b.category_name?.toLowerCase() || 'other'
          return catA.localeCompare(catB)
        })

        if (heading) heading.style.display = 'block'

        for (const item of items) {
          await addNewQuoteItem(item)
        }

        // Clear all checkboxes after loading items
        document
          .querySelectorAll(`${selectors.categoryCheckboxes}:checked, ${selectors.itemCheckboxes}:checked`)
          .forEach((cb) => (cb.checked = false))
      } catch (error) {
        console.error('Error loading items:', error)
      }
    })
  }

  // Handle clicking the "Add Same Item" button
  document.addEventListener('click', async (event) => {
    if (!event.target.classList.contains('add-same-item')) return
    const currentGroup = event.target.closest('.has_many_container.quote_items fieldset.has_many_fields')
    const itemId = currentGroup.querySelector(selectors.itemId)?.value
    if (!itemId) return
    const itemData = {
      item_id: itemId,
      item_name: currentGroup.querySelector(selectors.itemName)?.textContent,
      category_name: currentGroup.querySelector(selectors.category)?.textContent,
      discount: '0',
    }

    await addNewQuoteItem(itemData, true)
  })
})
