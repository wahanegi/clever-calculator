class ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :category_id, :fixed_parameters, :pricing_options, :is_disabled, :is_fixed, :is_open,
             :is_selectable_options, :open_parameters_label, :formula_parameters, :calculation_formula

  belongs_to :category
end
