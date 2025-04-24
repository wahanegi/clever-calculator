document.addEventListener('DOMContentLoaded', function () {
  const button = document.getElementById('load-items-button')
  if (!button) return

  button.addEventListener('click', function () {
    const selectedCategories = Array.from(document.querySelectorAll("input[name='quote[category_ids][]']:checked")).map(
      (cb) => cb.value,
    )

    if (selectedCategories.length === 0) {
      alert('Please select at least one category.')
      return
    }

    fetch('/admin/quotes/load_items_from_categories', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
      },
      body: JSON.stringify({ category_ids: selectedCategories }),
    })
      .then((response) => response.json())
      .then((items) => {
        const container = document.querySelector('.has_many_container.quote_items')
        if (!container) return

        items.forEach((item) => {
          // Trigger the "Add" button to create a new quote item
          const addButton = container.querySelector('.has_many_add')
          addButton?.click()

          // Find the newly added quote item fields
          const itemGroups = container.querySelectorAll('.has_many_fields')
          const lastItemGroup = itemGroups[itemGroups.length - 1]
          if (!lastItemGroup) return

          // Populate the fields
          const itemIdInput = lastItemGroup.querySelector('input.item-id-field')
          const itemNameSpan = lastItemGroup.querySelector('span.item-name-field')
          const pricingParamsInput = lastItemGroup.querySelector("input[id$='_pricing_parameters']")
          const discountInput = lastItemGroup.querySelector("input[id$='_discount']")

          if (itemIdInput) itemIdInput.value = item.item_id
          if (itemNameSpan) {
            itemNameSpan.textContent = item.item_name
            itemNameSpan.dataset.item_name = item.item_name
          }
          if (pricingParamsInput) pricingParamsInput.value = ''
          if (discountInput) discountInput.value = item.discount
        })
      })
      .catch((error) => {
        console.error('Error loading items:', error)
      })
  })
})
