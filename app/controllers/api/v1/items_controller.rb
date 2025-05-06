module Api
  module V1
    class ItemsController < BaseController
      def uncategorized
        items = Item.where(category_id: nil, is_disabled: false).order(:name)
        render json: ItemSerializer.new(items).serializable_hash, status: :ok
      end
    end
  end
end
