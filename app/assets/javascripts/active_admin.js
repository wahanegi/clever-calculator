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
  