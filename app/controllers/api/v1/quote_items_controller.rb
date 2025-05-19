module Api
  module V1
    class QuoteItemsController < BaseController
      before_action :set_quote
      before_action :set_quote_item, only: %i[update duplicate]

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      def index
        render json: group_serialize_quote_items(@quote.quote_items.includes(item: :category)), status: :ok
      end

      def create_from_item
        item = Item.find(params[:quote_item][:item_id])
        quote_item = @quote.quote_items.build(item: item, price: 0, discount: 0, final_price: 0)
        if quote_item.save
          render json: serialize_quote_item(quote_item), status: :created
        else
          render json: ErrorSerializer.new(quote_item.errors).serializable_hash, status: :unprocessable_entity
        end
      end

      def create_from_category
        category = Category.find(params[:quote_item][:category_id])
        items = category.items.map { |item| { item: item, price: 0, discount: 0, final_price: 0 } }
        quote_items = @quote.quote_items.create(items)

        render json: serialize_quote_item(quote_items, is_collection: true), status: :created
      end

      def update
        if @quote_item.update(quote_item_params)
          render json: serialize_quote_item(@quote_item), status: :ok
        else
          render json: ErrorSerializer.new(@quote_item.errors).serializable_hash, status: :unprocessable_entity
        end
      end

      def destroy_selected
        @quote.quote_items.where(id: params[:quote_item_ids]).destroy_all

        head :no_content
      end

      def duplicate
        cloned_quote_item = @quote_item.dup

        if cloned_quote_item.save
          render json: serialize_quote_item(cloned_quote_item), status: :created
        else
          render json: ErrorSerializer.new(cloned_quote_item.errors).serializable_hash, status: :unprocessable_entity
        end
      end

      private

      def set_quote
        @quote = current_user.quotes.find(params[:quote_id])
      end

      def set_quote_item
        @quote_item = @quote.quote_items.find(params[:id])
      end

      def quote_item_params
        params.require(:quote_item).permit(:discount, open_param_values: {}, select_param_values: {})
      end

      def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def serialize_quote_item(quote_item, **options)
        QuoteItemSerializer.new(quote_item, options).serializable_hash
      end

      def group_serialize_quote_items(quote_items)
        GroupedQuoteItemsSerializer.new(quote_items).serializable_hash
      end
    end
  end
end
