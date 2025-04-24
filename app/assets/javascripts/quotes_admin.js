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
          const addButton = container.querySelector('.has_many_add')
          addButton?.click()

          setTimeout(() => {
            const lastItemGroup = container.querySelectorAll('.has_many_fields').item(-1)
            const itemSelect = lastItemGroup?.querySelector("select[id$='_item_id']")
            const pricingParams = lastItemGroup?.querySelector("input[id$='_pricing_parameters']")
            const discount = lastItemGroup?.querySelector("input[id$='_discount']")

            if (itemSelect) itemSelect.value = item.item_id
            if (pricingParams) pricingParams.value = item.pricing_parameters
            if (discount) discount.value = item.discount
          }, 100)
        })
      })
  })
})
