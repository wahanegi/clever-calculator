module Api
  module V1
    class ItemsController < BaseController
      def uncategorized
        items = Item.enabled.without_category.order(:name)

        render json: ItemSerializer.new(items).serializable_hash, status: :ok
      end
    end
  end
end
