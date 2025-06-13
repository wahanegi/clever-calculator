//= require active_admin_helpers
//= require note_active_admin
//= require remove_item

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
    discount: 'input[id$=\'_discount\']',
    price: 'input[id$=\'_price\']',
    finalPrice: 'input[id$=\'_final_price\']',
    preview: '.quote-parameters-preview',
    categoryCheckboxes: 'input[name=\'quote[category_ids][]\']',
    itemCheckboxes: 'input[name=\'quote[item_ids][]\']',
    loadButton: '#load-items-button',
    parametersContainer: '.quote-parameters-container',
  }

  /**
   * Updates form fields for a quote item group
   * @param {HTMLElement} group - The quote item group element
   * @param {Object} itemData - Item data containing id, name, category, discount, and has_formula_parameters
   */
  const updateItemFields = (group, itemData) => {
    const fields = {
      itemId: group.querySelector(selectors.itemId),
      itemName: group.querySelector(selectors.itemName),
      category: group.querySelector(selectors.category),
      discount: group.querySelector(selectors.discount),
      price: group.querySelector(selectors.price),
      finalPrice: group.querySelector(selectors.finalPrice),
      parametersContainer: group.querySelector(selectors.parametersContainer),
    }

    if (fields.itemId) fields.itemId.value = itemData.item_id
    if (fields.itemName) {
      fields.itemName.textContent = itemData.item_name
      fields.itemName.dataset.item_name = itemData.item_name
    }
    if (fields.category) fields.category.textContent = itemData.category_name || 'Without Category'
    if (!fields.discount.value) fields.discount.value = '0'
    if (!fields.price.value) fields.price.value = '0'
    if (!fields.finalPrice.value) fields.finalPrice.value = '0'

    const shouldShowFields = itemData.has_formula_parameters
    if (fields.discount) fields.discount.closest('.input').style.display = shouldShowFields ? '' : 'none'
    if (fields.finalPrice) fields.finalPrice.closest('.input').style.display = shouldShowFields ? '' : 'none'
    if (fields.parametersContainer) fields.parametersContainer.style.display = shouldShowFields ? '' : 'none'

    // Format price and final_price on load to show $0.00
    if (fields.price) formatCurrencyInput(fields.price);
    if (fields.finalPrice) formatCurrencyInput(fields.finalPrice);
  }

  /**
   * Fetches and renders quote item parameters with existing values
   * @param {HTMLElement} group - The quote item group element
   * @param {string} itemId - The ID of the item
   */
  const renderQuoteParameters = async (group, itemId) => {
    const previewContainer = group.querySelector(selectors.preview)
    if (!previewContainer) {
      handleError('Preview container not found for group', null, { group })
      return
    }

    const quoteItemIndex = getQuoteItemIndex(group)
    if (!quoteItemIndex) {
      handleError('Quote item index not found for group', null, { group })
      return
    }

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
      if (paramName) open_param_values[paramName] = input.value
    })

    selectParamInputs.forEach((input) => {
      const paramName = input.dataset.paramName || input.name.match(/\[select_param_values\]\[(.+)\]/)?.[1]
      if (paramName) select_param_values[paramName] = input.value
    })

    try {
      const response = await fetchWithConfig('/admin/quotes/render_quote_item_parameters', {
        item_id: itemId,
        open_param_values,
        select_param_values,
      })
      const html = await response.text()
      if (!html.trim()) {
        handleError('Empty response from render_quote_item_parameters', null, { itemId })
      }
      previewContainer.innerHTML = html.replace(/NEW_RECORD/g, quoteItemIndex)
    } catch (error) {
      handleError('Error rendering quote parameters', error, { itemId })
    }
  }

  /**
   * Adds a new quote item to the form
   * @param {Object} itemData - Item data containing id, name, category, and discount
   */
  const addNewQuoteItem = async (itemData, insertAfter = null) => {
    const addButton = container.querySelector(selectors.addButton)
    if (!addButton || !addButton.dataset.html) {
      handleError('Quote item add button or template not found')
      return
    }

    const existingIndices = Array.from(container.querySelectorAll('input[name^="quote[quote_items_attributes]"]'))
      .map((input) => parseInt(input.name.match(/quote_items_attributes\]\[(\d+)\]/)?.[1]))
      .filter((index) => !isNaN(index))
    const newIndex = existingIndices.length ? Math.max(...existingIndices) + 1 : 0

    const newItemHtml = addButton.dataset.html.replace(/NEW_QUOTE_ITEM_RECORD/g, newIndex)
    const tempDiv = document.createElement('div')
    tempDiv.innerHTML = newItemHtml
    // Add an event listener to the discount input in the new item template
    const discountInput = tempDiv.querySelector('input.discount-input')

    if (discountInput) {
      discountInput.addEventListener('input', handleDiscountInput)
      discountInput.addEventListener('click', handleDiscountClick)
    }

    const newItemGroup = tempDiv.firstElementChild

    // Insert either after the clicked item, or at the end
    if (insertAfter && insertAfter.parentNode) {
      insertAfter.parentNode.insertBefore(newItemGroup, insertAfter.nextSibling)
    } else {
      container.insertBefore(newItemGroup, addButton)
    }

    updateItemFields(newItemGroup, itemData)
    if (itemData.item_id) await renderQuoteParameters(newItemGroup, itemData.item_id)
  }

  /**
   * Initializes existing quote items and renders parameters.
   * @param {number} [retryCount=0] - Number of retry attempts.
   */
  const initializeQuoteItems = (retryCount = 0) => {
    const maxRetries = 3
    const itemGroups = document.querySelectorAll(selectors.itemGroups)

    if (itemGroups.length === 0 && retryCount < maxRetries) {
      setTimeout(() => initializeQuoteItems(retryCount + 1), 0)
      return
    }

    itemGroups.forEach(async (group, index) => {
      const itemId = group.querySelector(selectors.itemId)?.value
      if (itemId) {
        try {
          const response = await fetchWithConfig('/admin/quotes/load_items', {
            item_ids: [itemId],
          })
          const items = await response.json()
          const itemData = items[0]

          updateItemFields(group, itemData)
          if (itemData.has_formula_parameters) {
            await renderQuoteParameters(group, itemId)
          }
        } catch (error) {
          handleError('Error fetching item data for initialization', error, { itemId })
        }
      } else {
        handleError('No itemId found for QuoteItem', null, {
          index,
          groupHtml: group.outerHTML.substring(0, 200) + '...',
        })
      }
    })
  }

  /**
   * Initializes the form, showing the heading if quote items exist.
   */
  const initializeForm = () => {
    const heading = container.querySelector(selectors.heading)
    if (container.querySelectorAll(selectors.itemGroups).length > 0 && heading) {
      heading.style.display = 'block'
    }
    setTimeout(() => initializeQuoteItems(), 0)

    // Format all read-only price fields
    document.querySelectorAll('input.read-only-price').forEach((input) => {
      formatCurrencyInput(input);
    });
  }

  if (window.location.pathname.match(/\/admin\/quotes\/\d+\/edit/)) {
    document
      .querySelectorAll(`${selectors.categoryCheckboxes}, ${selectors.itemCheckboxes}`)
      .forEach((cb) => (cb.checked = false))
  }

  /**
   * Handles the "Load Items" button click, fetching and adding selected items.
   */
  const handleLoadItems = async () => {
    const loadItemsButton = document.querySelector(selectors.loadButton)
    if (!loadItemsButton) return

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

        items.sort((a, b) => {
          const catA = a.category_name?.toLowerCase() || 'other'
          const catB = b.category_name?.toLowerCase() || 'other'
          return catA.localeCompare(catB)
        })

        const heading = container.querySelector(selectors.heading)
        if (heading) heading.style.display = 'block'

        for (const item of items) {
          await addNewQuoteItem(item)
        }

        document
          .querySelectorAll(`${selectors.categoryCheckboxes}:checked, ${selectors.itemCheckboxes}:checked`)
          .forEach((cb) => (cb.checked = false))
      } catch (error) {
        handleError('Error loading items', error)
      }

      if (window.dropdownUpdateFunctions) {
        window.dropdownUpdateFunctions.forEach((updateFn) => updateFn())
      }
    })
  }

  /**
   * Handles the "Add Same Item" button click, duplicating the current item.
   */
  const handleAddSameItem = () => {
    document.addEventListener('click', async (event) => {
      if (!event.target.classList.contains('add-same-item')) return
      const currentGroup = event.target.closest('.has_many_container.quote_items fieldset.has_many_fields')
      const itemId = currentGroup.querySelector(selectors.itemId)?.value
      if (!itemId) return

      try {
        const response = await fetchWithConfig('/admin/quotes/load_items', {
          item_ids: [itemId],
        })
        const items = await response.json()
        const itemData = items[0]

        await addNewQuoteItem(itemData, currentGroup)
      } catch (error) {
        handleError('Error fetching item data for add same item', error, { itemId })
      }
    })
  }
  const handleDiscountInput = (e) => {
    const value = e.target.value
    let discountValue = parseFloat(value)

    if (isNaN(discountValue)) return

    const min = parseFloat(e.target.min) || 0
    const max = parseFloat(e.target.max) || 100
    discountValue = Math.max(min, Math.min(max, discountValue))

    e.target.value = discountValue
  }

  const handleDiscountClick = (e) => {
    const value = e.target.value
    if (['0.0', '0'].includes(value)) {
      e.target.value = ''
    }
  }

  /*
   * Handles the input event for discount inputs
   */
  document.querySelectorAll('input.discount-input').forEach((input) => {
    input.addEventListener('input', handleDiscountInput)
    input.addEventListener('click', handleDiscountClick)
  })

  // Initialize the form and event handlers
  initializeForm()
  handleLoadItems()
  handleAddSameItem()
  handleRemoveItem()
})

