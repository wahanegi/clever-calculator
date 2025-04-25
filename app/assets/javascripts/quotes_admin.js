document.addEventListener('DOMContentLoaded', function () {
  const button = document.getElementById('load-items-button')
  if (!button) return

  button.addEventListener('click', function () {
    const selectedCategories = Array.from(document.querySelectorAll("input[name='quote[category_ids][]']:checked")).map(
      (cb) => cb.value,
    )

    const selectedItems = Array.from(document.querySelectorAll("input[name='quote[item_ids][]']:checked")).map(
      (cb) => cb.value,
    )

    if (selectedCategories.length === 0 && selectedItems.length === 0) {
      alert('Please select at least one category or item.')
      return
    }

    fetch('/admin/quotes/load_items', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
      },
      body: JSON.stringify({
        category_ids: selectedCategories,
        item_ids: selectedItems,
      }),
    })
      .then((response) => response.json())
      .then((items) => {
        const container = document.querySelector('.has_many_container.quote_items')
        if (!container) return

        items.forEach((item) => {
          const addButton = container.querySelector('.has_many_add')
          addButton?.click()

          const itemGroups = container.querySelectorAll('.has_many_fields')
          const lastItemGroup = itemGroups[itemGroups.length - 1]
          if (!lastItemGroup) return

          const itemIdInput = lastItemGroup.querySelector('input.item-id-field')
          const itemNameSpan = lastItemGroup.querySelector('span.item-name-field')
          const discountInput = lastItemGroup.querySelector("input[id$='_discount']")
          const previewContainer = lastItemGroup.querySelector('.quote-parameters-preview')

          if (itemIdInput) itemIdInput.value = item.item_id
          if (itemNameSpan) {
            itemNameSpan.textContent = item.item_name
            itemNameSpan.dataset.item_name = item.item_name
          }
          if (discountInput) discountInput.value = item.discount

          setTimeout(() => {
            const itemGroups = container.querySelectorAll('.has_many_fields')
            const lastItemGroup = itemGroups[itemGroups.length - 1]
            if (!lastItemGroup) return

            const quoteItemIndex = lastItemGroup
              .querySelector('input[name^="quote[quote_items_attributes]"]')
              ?.name.match(/quote_items_attributes\]\[(\d+)\]/)?.[1]

            if (!quoteItemIndex) return

            fetch('/admin/quotes/render_quote_item_parameters', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
              },
              body: JSON.stringify({ item_id: item.item_id }),
            })
              .then((response) => response.text())
              .then((html) => {
                if (previewContainer) {
                  const rendered = html.replace(/NEW_RECORD/g, quoteItemIndex)
                  previewContainer.innerHTML = rendered
                }
              })
          }, 0)
        })

        document.querySelectorAll("input[name='quote[category_ids][]']:checked").forEach((cb) => (cb.checked = false))
        document.querySelectorAll("input[name='quote[item_ids][]']:checked").forEach((cb) => (cb.checked = false))
      })
      .catch((error) => {
        console.error('Error loading items:', error)
      })
  })
})
