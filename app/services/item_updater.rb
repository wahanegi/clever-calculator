class ItemUpdater
  attr_reader :item, :params, :session_data

  def initialize(item, params, session_data = nil)
    @item = item
    @params = params
    @session_data = session_data
  end

  def call
    item.assign_attributes(params.except("item_pricings_attributes"))

    pricing = item.item_pricings.first_or_initialize

    reset_all_fields(pricing)

    case item.pricing_type
    when "fixed"
      update_fixed(pricing)
    when "open"
      update_open(pricing)
    when "fixed_open"
      update_fixed_open(pricing)
    end

    ActiveRecord::Base.transaction do
      pricing.save!
      item.save!
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug "‼️ Failed to update item: #{e.record.errors.full_messages}"
    false
  end

  private

  def reset_all_fields(pricing)
    pricing.default_fixed_price    = nil
    pricing.fixed_parameters       = {}
    pricing.open_parameters_label  = []
    pricing.pricing_options        = {}
    pricing.formula_parameters     = {}
    pricing.calculation_formula    = nil
    pricing.is_open               = false
    pricing.is_selectable_options = false
  end

  def update_fixed(pricing)
    price = params.dig("item_pricings_attributes", "0", "default_fixed_price")
    pricing.default_fixed_price = price.presence
  end

  def update_open(pricing)
    labels_string = params.dig("item_pricings_attributes", "0", "open_parameters_label_as_string") ||
                    params.dig("item_pricings_attributes", "1", "open_parameters_label_as_string")
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

    pricing.is_open = pricing.open_parameters_label.any?
    pricing.is_selectable_options = pricing.pricing_options.any?
  end
end
