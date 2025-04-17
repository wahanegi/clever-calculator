//= require active_admin/base


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


document.addEventListener("DOMContentLoaded", function () {
  const addParamLinks = document.querySelectorAll(".store-and-navigate");

  if (!addParamLinks.length) return;

  addParamLinks.forEach(link => {
    link.addEventListener("click", function (event) {
      event.preventDefault();

      const nameField = document.querySelector("#item_name");
      const descriptionField = document.querySelector("#item_description");
      const categoryField = document.querySelector("#item_category_id");

      const data = {
        name: nameField?.value || "",
        description: descriptionField?.value || "",
        category_id: categoryField?.value || ""
      };

      const itemId = link.dataset.itemId || "new"; // 💡 правильний спосіб

      fetch(`/admin/items/${itemId}/save_meta_to_session`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(data)
      }).then(response => {
        if (response.ok) {
          window.location.href = link.dataset.redirect; // 💥 редірект тільки після успіху
        } else {
          alert("⚠️ Failed to save temporary data to session");
        }
      });
    });
  });
});


// clear new item session
document.addEventListener("DOMContentLoaded", function () {
  const newItemLink = document.querySelector('a[href$="/admin/items/new"]');

  if (newItemLink) {
    newItemLink.addEventListener("click", function (event) {
      event.preventDefault();

      fetch("/admin/items/new/clear_session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
      })
        .then((response) => {
          if (response.ok) {
            window.location.href = "/admin/items/new"; 
          } else {
            alert("❌ Session clear failed");
          }
        });
    });
  }
});


document.addEventListener("DOMContentLoaded", function () {
  const cancelButton = document.querySelector(".custom-cancel-button");

  if (cancelButton) {
    cancelButton.addEventListener("click", function () {
      const itemId = cancelButton.dataset.itemId;

      fetch(`/admin/items/${itemId}/clear_session`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(() => {
        window.location.href = "/admin/items";
      });
    });
  }
});

