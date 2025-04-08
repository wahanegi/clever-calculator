class ItemUpdater
  attr_reader :item, :params, :session_data

  def initialize(item, params, session_data = nil)
    @item = item
    @params = params
    @session_data = session_data
  end

  def call
    assign_item_attributes
    pricing = item.item_pricing || item.build_item_pricing
    reset_all_fields(pricing)
    update_by_pricing_type(pricing)
    persist!(pricing)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug "‼️ Failed to update item: #{e.record.errors.full_messages}"
    false
  end

  private

  def assign_item_attributes
    item.assign_attributes(params.except("item_pricing_attributes"))
  end

  def persist!(pricing)
    ActiveRecord::Base.transaction do
      pricing.save!
      item.save!
    end
    true
  end

  def update_by_pricing_type(pricing)
    case item.pricing_type
    when "fixed"      then update_fixed(pricing)
    when "open"       then update_open(pricing)
    when "fixed_open" then update_fixed_open(pricing)
    end
  end

  def reset_all_fields(pricing)
    pricing.assign_attributes(
      default_fixed_price: nil,
      fixed_parameters: {},
      open_parameters_label: [],
      pricing_options: {},
      formula_parameters: {},
      # calculation_formula: nil,
      is_open: false,
      is_selectable_options: false
    )
  end

  def update_fixed(pricing)
    price = params.dig("item_pricing_attributes", "default_fixed_price")
    pricing.default_fixed_price = price.presence
  end

  def update_open(pricing)
    labels_string = params.dig("item_pricing_attributes", "open_parameters_label_as_string")
    labels = labels_string.to_s.split(',').map(&:strip).reject(&:blank?)
  
    pricing.open_parameters_label = labels
    pricing.is_open = labels.any?
  end

  def update_fixed_open(pricing)
    return unless session_data

    data = session_data.deep_symbolize_keys
    pricing.fixed_parameters = data[:fixed] || {}
    pricing.open_parameters_label = data[:open] || []
    pricing.pricing_options = data[:select] || {}
    pricing.formula_parameters = data[:formula_parameters] || []

    pricing.is_open = pricing.open_parameters_label.any?
    pricing.is_selectable_options = pricing.pricing_options.any?
  end
end
