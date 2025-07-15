module Api
  module V1
    class QuoteItemsController < BaseController
      before_action :set_quote
      before_action :set_quote_item, only: %i[update duplicate]

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

      def index
        @quote_items = @quote.quote_items.includes({ item: :category }, :note).order('items.id')
        render json: group_serialize_quote_items(@quote_items), status: :ok
      end

      def create_from_item
        item = Item.find(params[:quote_item][:item_id])
        quote_item = @quote.quote_items.build(default_quote_item_attributes(item))
        if quote_item.save
          render json: serialize_quote_item(quote_item), status: :created
        else
          render json: serialize_errors(quote_item.errors), status: :unprocessable_entity
        end
      end

      def create_from_category
        category = Category.find(params[:quote_item][:category_id])
        items = category.items.enabled.map { |item| default_quote_item_attributes(item) }
        quote_items = nil

        ActiveRecord::Base.transaction do
          quote_items = @quote.quote_items.create!(items)
        end

        render json: serialize_quote_item(quote_items, is_collection: true), status: :created
      end

      def update
        if @quote_item.update(quote_item_params)
          render json: serialize_quote_item(@quote_item), status: :ok
        else
          render json: serialize_errors(@quote_item.errors), status: :unprocessable_entity
        end
      end

      def destroy_selected
        @quote.quote_items.where(id: params[:quote_item_ids]).destroy_all

        head :no_content
      end

      def duplicate
        cloned_quote_item = @quote.quote_items.build(default_quote_item_attributes(@quote_item.item))

        if cloned_quote_item.save
          render json: serialize_quote_item(cloned_quote_item), status: :created
        else
          render json: serialize_errors(cloned_quote_item.errors), status: :unprocessable_entity
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

      def render_record_invalid
        render json: { error: "One or more quote items could not be saved. Please check the item data and try again." },
               status: :unprocessable_entity
      end

      def serialize_quote_item(quote_item, **options)
        QuoteItemSerializer.new(quote_item, options).serializable_hash
      end

      def group_serialize_quote_items(quote_items)
        GroupedQuoteItemsSerializer.new(quote_items).serializable_hash
      end

      def serialize_errors(errors)
        ErrorSerializer.new(errors).serializable_hash
      end

      def default_quote_item_attributes(item)
        { item_id: item.id, price: 0, discount: 0, final_price: 0 }
      end
    end
  end
end
