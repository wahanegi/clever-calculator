// --- Parameter type switch ---
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

// --- Add Option and Delete ---
document.addEventListener("DOMContentLoaded", () => {
    const wrapper = document.getElementById("select-options-wrapper");
    const addBtn = document.getElementById("add-option-button");

    const createOptionRow = () => {
        const row = document.createElement("div");
        row.className = "select-option-row";

        row.innerHTML = `
        <div class="select-field">
          <label>Description</label>
          <input type="text" name="select_options[][description]" />
        </div>
        <div class="select-field">
          <label>Value</label>
          <input type="text" name="select_options[][value]" />
        </div>
        <button type="button" class="delete-option-button button light">Delete</button>
      `;

        row.querySelector(".delete-option-button").addEventListener("click", () => {
            if (wrapper.querySelectorAll(".select-option-row").length > 2) {
                row.remove();
            } else {
                alert("At least 2 options are required.");
            }
        });

        return row;
    };

    addBtn.addEventListener("click", () => {
        const newRow = createOptionRow();
        wrapper.appendChild(newRow);
    });


    wrapper.querySelectorAll(".select-option-row").forEach((row) => {
        const delBtn = row.querySelector(".delete-option-button");
        delBtn.addEventListener("click", () => {
            if (wrapper.querySelectorAll(".select-option-row").length > 2) {
                row.remove();
            } else {
                alert("At least 2 options are required.");
            }
        });
    });
});

// --- Save meta info (name, desc, category_id) before transition ---
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

            const itemId = link.dataset.itemId || "new";

            fetch(`/admin/items/${itemId}/save_meta_to_session`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify(data)
            }).then(response => {
                if (response.ok) {
                    window.location.href = link.dataset.redirect;
                } else {
                    alert("⚠️ Failed to save temporary data to session");
                }
            });
        });
    });
});

