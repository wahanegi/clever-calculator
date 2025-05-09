module Api
  module V1
    class SelectableOptionsController < BaseController
      def index
        categories = Category.enabled.joins(:items).order(:name).distinct
        items = Item.enabled.without_category.order(:name)

        render json: SelectableOptionsSerializer.new(categories + items).serializable_hash, status: :ok
      end
    end
  end
end
