ActiveAdmin.register ItemPricing do
    belongs_to :item
  
    permit_params :item_id, :is_open, :is_selectable_options, :fixed_parameters, :open_parameters_label, :pricing_options
  
    form do |f|
      f.semantic_errors
  
      f.inputs "Parameter Type" do
        f.input :parameter_type, as: :radio, label: "Choose Parameter Type", collection: ["Fixed", "Open", "Select"], input_html: { required: true }
      end
  
      f.inputs "Fixed Parameter", id: "fixed_fields", style: "display:none;" do
        f.input :fixed_parameter_name, label: "Parameter Name"
        f.input :fixed_parameter_value, label: "Parameter Value"
      end
  
      f.inputs "Open Parameter", id: "open_fields", style: "display:none;" do
        f.input :open_parameter_name, label: "Parameter Name"
      end
  
      f.inputs "Select Parameter", id: "select_fields", style: "display:none;" do
        f.input :select_parameter_name, label: "Parameter Name"
  
        10.times do |i|
          f.input "option_description_#{i+1}", label: "Parameter Description #{i+1}"
          f.input "option_value_#{i+1}", label: "Parameter Value #{i+1}"
        end
      end
  
      f.actions
    end
  
    sidebar :help do
      "Choose a parameter type and fill in corresponding fields."
    end
  end
  