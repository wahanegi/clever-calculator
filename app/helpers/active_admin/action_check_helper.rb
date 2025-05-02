module ActiveAdmin
  module ActionCheckHelper
    def edit_action?
      params[:action] == 'edit'
    end
  end
end
