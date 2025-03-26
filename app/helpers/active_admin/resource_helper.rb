module ActiveAdmin
  module ResourceHelper
    def edit_action?
      params[:action] == 'edit'
    end
  end
end
