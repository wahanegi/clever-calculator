module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.where(is_disabled: false).includes(:items).order(:name)
        render json: CategorySerializer.new(categories, { include: [:items] }).serializable_hash, status: :ok
      end
    end
  end
end
