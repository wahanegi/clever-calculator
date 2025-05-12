module ActiveAdmin
  module ItemsHelper
    def parameter_display_name(key)
      key.to_s.tr("_", " ")
    end
  end
end
