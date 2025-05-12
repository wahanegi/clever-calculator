document.addEventListener('DOMContentLoaded', () => {
  // Main container for quote items
  const container = document.querySelector('.has_many_container.quote_items')
  if (!container) return

  // DOM selectors for commonly used elements
  const selectors = {
    heading: 'h3',
    addButton: '.has_many_add',
    itemGroups: '.has_many_fields',
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
    addButton?.click()

    // Wait for DOM update
    await new Promise((resolve) => setTimeout(resolve, 0))

    const itemGroups = container.querySelectorAll(selectors.itemGroups)
    const lastItemGroup = itemGroups[itemGroups.length - 1]
    if (!lastItemGroup) return

    updateItemFields(lastItemGroup, itemData, isDuplicate)
    await renderQuoteParameters(lastItemGroup, itemData.item_id)
  }

  // Initialization
  // Show heading if quote items exist on page load
  const heading = container.querySelector(selectors.heading)
  if (container.querySelectorAll(selectors.itemGroups).length > 0 && heading) {
    heading.style.display = 'block'
  }

  if (window.location.pathname.match(/\/admin\/quotes\/\d+\/edit/)) {
    document
      .querySelectorAll(`${selectors.categoryCheckboxes}, ${selectors.itemCheckboxes}`)
      .forEach((cb) => (cb.checked = false))
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

      if (window.dropdownUpdateFunctions) {
        window.dropdownUpdateFunctions.forEach((updateFn) => updateFn())
      }
    })
  }

  // Handle clicking the "Add Same Item" button
  document.addEventListener('click', async (event) => {
    if (!event.target.classList.contains('add-same-item')) return

    const currentGroup = event.target.closest(selectors.itemGroups)
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

  document.querySelectorAll(selectors.itemGroups).forEach(async (group) => {
    const itemId = group.querySelector(selectors.itemId)?.value
    if (itemId) await renderQuoteParameters(group, itemId)
  })
})
