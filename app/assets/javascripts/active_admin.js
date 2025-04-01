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
  const fixedSection = document.querySelector('#pricing_fixed')
  const openSection = document.querySelector('#pricing_open')
  const fixedOpenSection = document.querySelector('#pricing_fixed_open')

  // Toggle visibility and enable/disable inputs for fixed section
  fixedSection.style.display = fixed ? 'block' : 'none'
  fixedSection.querySelectorAll('input, textarea, select').forEach((input) => {
    input.disabled = !fixed
  })

  // Toggle visibility and enable/disable inputs for open section
  openSection.style.display = open ? 'block' : 'none'
  openSection.querySelectorAll('input, textarea, select').forEach((input) => {
    input.disabled = !open
  })

  // Toggle visibility and enable/disable inputs for fixed_open section
  fixedOpenSection.style.display = fixed_open ? 'block' : 'none'
  fixedOpenSection
    .querySelectorAll('input, textarea, select')
    .forEach((input) => {
      input.disabled = !fixed_open
    })
}

// Run on page load to set initial state
document.addEventListener('DOMContentLoaded', () => {
  const selectedType =
    document.querySelector('input[name="item[pricing_type]"]:checked')?.value ||
    'fixed'
  updatePricingType(selectedType)
})

document.addEventListener("DOMContentLoaded", function () {
  function toggleFields() {
    const val = document.querySelector('input[name="parameter_type"]:checked');
    const type = val ? val.value : "";

    document.getElementById("fixed_fields").style.display = type === "Fixed" ? "block" : "none";
    document.getElementById("open_fields").style.display = type === "Open" ? "block" : "none";
    document.getElementById("select_fields").style.display = type === "Select" ? "block" : "none";
  }

  const radios = document.querySelectorAll('input[name="parameter_type"]');
  radios.forEach((radio) => {
    radio.addEventListener("change", toggleFields);
  });

  toggleFields();
});
