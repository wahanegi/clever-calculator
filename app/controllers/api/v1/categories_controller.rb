module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.where(is_disabled: false).order(:name)
        render json: CategorySerializer.new(categories).serializable_hash, status: :ok
      end
    end
  end
end
