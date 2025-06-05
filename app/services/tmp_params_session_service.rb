class TmpParamsSessionService
  def initialize(session, item_key)
    @session = session
    @item_key = item_key.to_s
    @session[:tmp_params] ||= {}
    @session[:tmp_params][@item_key] ||= {}
  end

  def all
    @session[:tmp_params][@item_key]
  end

  def get(symbol_key)
    all.deep_symbolize_keys[symbol_key]
  end

  def set(symbol_key, value)
    @session[:tmp_params][@item_key][symbol_key.to_s] = value
  end

  def delete_all
    Rails.logger.debug "!!!!!!Deleting all tmp params"
    Rails.logger.debug "!!!!!!Before clearing tmp params: #{@session[:tmp_params]}"
    @session[:tmp_params].clear
    Rails.logger.debug "!!!!!!After clearing tmp params: #{@session[:tmp_params]}"
  end

  def add_formula_parameter(name)
    params = all
    params["formula_parameters"] ||= []
    params["formula_parameters"] << name unless params["formula_parameters"].include?(name)
  end

  def remove_formula_parameter(name)
    params = all
    params["formula_parameters"]&.delete(name)
  end

  def update_with_tmp_to_item(item)
    data = all.deep_symbolize_keys
    assign_param_values(item, data)
    assign_flags(item)
  end

  def store_meta(name:, description:, category_id:)
    set(:name, name)
    set(:description, description)
    set(:category_id, category_id)
  end

  private

  def assign_param_values(item, data)
    item.fixed_parameters       = data[:fixed] || {}
    item.open_parameters_label  = data[:open] || []
    item.pricing_options        = data[:select] || {}
    item.formula_parameters     = data[:formula_parameters] || []
    item.calculation_formula    = data[:calculation_formula]
  end

  def assign_flags(item)
    item.is_open                = item.open_parameters_label.any?
    item.is_selectable_options  = item.pricing_options.any?
    item.is_fixed               = item.fixed_parameters.any?
  end
end
