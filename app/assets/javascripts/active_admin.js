//= require active_admin/base
document.addEventListener("DOMContentLoaded", () => {
    const toggleFields = () => {
      const type = document.querySelector('input[name="item_pricing[parameter_type]"]:checked')?.value;
      document.getElementById('fixed_fields').style.display = type === 'Fixed' ? 'block' : 'none';
      document.getElementById('open_fields').style.display = type === 'Open' ? 'block' : 'none';
      document.getElementById('select_fields').style.display = type === 'Select' ? 'block' : 'none';
    };
  
    document.querySelectorAll('input[name="item_pricing[parameter_type]"]').forEach(radio => {
      radio.addEventListener('change', toggleFields);
    });
  
    toggleFields();
});

document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('form');
  if (!form) {
    return;
  }

  // Function to toggle the Add New Note button visibility
  function toggleAddNoteButton(addButton, noteContainer) {
    const noteFields = noteContainer.querySelectorAll('.has_many_fields:not(.has_many_remove)');
    if (noteFields.length >= 1) {
      addButton.style.display = 'none';
    } else {
      addButton.style.display = 'inline-block';
    }
  }

  // Set up each Note container
  function setupNoteContainer(noteContainer) {
    const addNoteButton = noteContainer.querySelector('.has_many_add');
    if (!addNoteButton) {
      return;
    }
    // Hide button immediately on click
    addNoteButton.addEventListener('click', function() {
      addNoteButton.style.display = 'none';
      setTimeout(() => toggleAddNoteButton(addNoteButton, noteContainer), 200);
    });

    // Show button again if Note is removed
    noteContainer.addEventListener('click', function(event) {
      if (event.target.classList.contains('has_many_remove')) {
        setTimeout(() => toggleAddNoteButton(addNoteButton, noteContainer), 200);
      }
    });
  }
  // Watch for dynamically added QuoteItems in new form
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.addedNodes.length) {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === 1) { // Element node
            const noteContainers = node.querySelectorAll('.has_many_container.note');
            noteContainers.forEach(function(noteContainer) {
              setupNoteContainer(noteContainer);
            });
          }
        });
      }
    });
  });
  observer.observe(form, { childList: true, subtree: true });
});