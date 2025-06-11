if Rails.env.development?
  def create_item!(index, **options)
    Rails.logger.info "Creating Item: ##{index}"
    Item.create!(**options)
  end

  # rubocop:disable Metrics/ParameterLists
  def generate_item_attributes(list_parameters,
                               category,
                               is_disabled: false,
                               include_fixed_params: true,
                               include_open_params: true,
                               include_selectable_params: true)
    # rubocop:enable Metrics/ParameterLists
    params = {}
    params.merge!(fixed_parameters) if include_fixed_params
    params.merge!(open_parameters) if include_open_params
    params.merge!(selectable_option_parameters(rand(2..10))) if include_selectable_params

    calculation_formula = build_calculation_formula(params)
    formula_parameters = build_formula_parameters(params)

    {
      name: generate_name(list_parameters),
      description: Faker::Food.description,
      category: category,
      is_disabled: is_disabled,
      calculation_formula: calculation_formula,
      formula_parameters: formula_parameters
    }.merge(params)
  end

  def open_parameters
    {
      is_open: true,
      open_parameters_label: ["#{Faker::Lorem.unique.word} (open)"]
    }
  end

  def fixed_parameters
    {
      is_fixed: true,
      fixed_parameters: {
        "#{Faker::Lorem.unique.word} (fixed)" => Faker::Number.unique.number(digits: 3).to_s
      }
    }
  end

  def selectable_option_parameters(count = 2)
    {
      is_selectable_options: true,
      pricing_options: {
        "#{Faker::Lorem.unique.word} (select)" => {
          "options" => count.times.map do
            {
              "value" => Faker::Number.unique.number(digits: 3).to_s,
              "description" => Faker::Lorem.unique.word
            }
          end,
          "value_label" => "value label"
        }
      }
    }
  end

  def build_formula_parameters(params)
    params.map do |k, v|
      case k
      when :fixed_parameters, :pricing_options
        v.keys.map(&:to_s)
      when :open_parameters_label
        v.map(&:to_s)
      end
    end.flatten.compact
  end

  def build_calculation_formula(params, operator = ' + ')
    params.map do |k, v|
      case k
      when :fixed_parameters, :pricing_options
        v.keys.map { |key| DentakuKeyEncoder.encode(key.to_s) }.join(operator)
      when :open_parameters_label
        v.map { |key| DentakuKeyEncoder.encode(key.to_s) }.join(operator)
      end
    end.compact.join(operator)
  end

  def generate_name(params)
    "#{Faker::Lorem.unique.word} (#{params.join(', ')})"
  end

  if Item.count.zero?
    category = Category.enabled.sample
    items = [
      # Item with category
      # Empty params
      generate_item_attributes(%w[empty], category, include_fixed_params: false, include_open_params: false, include_selectable_params: false),
      # Fixed params
      generate_item_attributes(%w[fixed], category, include_fixed_params: false, include_open_params: false),
      # Selectable options params
      generate_item_attributes(%w[selectable], category, include_fixed_params: false, include_open_params: false, include_selectable_params: false),
      # Open params
      generate_item_attributes(%w[open], category, include_fixed_params: false, include_selectable_params: false),
      # All params
      generate_item_attributes(%w[open fixed selectable], category),
      # Disabled item
      generate_item_attributes(%w[open fixed selectable], category, is_disabled: true),

      # Item without category
      # Empty params
      generate_item_attributes(%w[empty], nil, include_fixed_params: false, include_open_params: false, include_selectable_params: false),
      # Fixed params
      generate_item_attributes(%w[fixed], nil, include_open_params: false, include_selectable_params: false),
      # Selectable options params
      generate_item_attributes(%w[selectable], nil, include_fixed_params: false, include_open_params: false),
      # Open params
      generate_item_attributes(%w[open], nil, include_fixed_params: false, include_selectable_params: false),
      # All params
      generate_item_attributes(%w[open fixed selectable], nil),
      # Disabled item
      generate_item_attributes(%w[open fixed selectable], nil, is_disabled: true)
    ]

    Rails.logger.info 'Creating items'
    items.each.with_index do |item, index|
      create_item! index, **item
    end
  end
end
