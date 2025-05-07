module Api
  module V1
    class QuoteItemsController < BaseController
      before_action :set_quote
      before_action :set_quote_item, only: %i[update destroy]

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      def create_from_item
        item = Item.find(params[:quote_item][:item_id])
        quote_item = @quote.quote_items.create(item: item)

        render json: serialize_quote_item(quote_item), status: :created
      end

      def create_from_category
        category = Category.find(params[:quote_item][:category_id])
        items = category.items.map { |item| { item: item } }
        quote_items = @quote.quote_items.create(items)

        render json: serialize_quote_item(quote_items, is_collection: true), status: :created
      end

      # not working
      def update
        if @quote_item.update(quote_item_params)
          render json: serialize_quote_item(@quote_item), status: :ok
        else
          render json: ErrorSerializer.new(@quote_item.errors).serializable_hash, status: :unprocessable_entity
        end
      end

      # not working
      def destroy
        @quote_item.destroy

        head :no_content
      end

      private

      def set_quote
        @quote = current_user.quotes.find(params[:quote_id])
      end

      def set_quote_item
        @quote_item = @quote.quote_items.find(params[:id])
      end

      # not working
      def quote_item_params
        params.require(:quote_item).permit(:discount, :open_value, :select_value, :item_id)
      end

      def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def serialize_quote_item(quote_item, **options)
        options[:include] ||= [:item]

        QuoteItemSerializer.new(quote_item, options).serializable_hash
      end
    end
  end
end
