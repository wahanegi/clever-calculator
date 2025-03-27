//= require active_admin/base

const updatePricingType = (pricing_type) => {
  switch (pricing_type) {
    case 'fixed':
      showPricingForm(true, false, false)
      break
    case 'open':
      showPricingForm(false, true, false)
      break
    case 'fixed_open':
      showPricingForm(false, false, true)
      break
    default:
      showPricingForm(false, false, false); //  Hide all if pricing_type is unknown
  }
}

const showPricingForm = (fixed, open, fixed_open) => {
  document.querySelector('#pricing_fixed').style.display = fixed ? 'block' : 'none'
  document.querySelector('#pricing_open').style.display = open ? 'block' : 'none'
  document.querySelector('#pricing_fixed_open').style.display = fixed_open ? 'block' : 'none'
}