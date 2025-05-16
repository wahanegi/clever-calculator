module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.enabled.joins(:items).includes(:items).order(:name)

        render json: CategorySerializer.new(categories, { include: [:items] }).serializable_hash, status: :ok
      end
    end
  end
end
