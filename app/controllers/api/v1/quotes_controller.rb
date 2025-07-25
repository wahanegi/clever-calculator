module Api
  module V1
    class QuotesController < BaseController
      before_action :set_quote, only: %i[update reset show]

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      def show
        render json: serialize_quote(@quote), status: :ok
      end

      def create
        quote = current_user.quotes.build(quote_params_with_defaults)

        if quote.save
          render json: serialize_quote(quote), status: :created
        else
          render json: { errors: quote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @quote.update(quote_params)
          render json: serialize_quote(@quote), status: :ok
        else
          render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def generate_file
        quote = current_user.quotes
                            .includes(:customer, :user, :contract_type, quote_items: [:note, { item: :category }])
                            .find(params[:id])

        docx = QuoteDocxGenerator.new(quote).call

        send_data docx,
                  type: Mime[:docx],
                  disposition: 'attachment',
                  filename: "quote.docx"
      end

      def reset
        @quote.quote_items.destroy_all

        render json: serialize_quote(@quote), status: :ok
      end

      private

      def set_quote
        @quote = current_user.quotes.find(params[:id])
      end

      def render_not_found
        render json: { error: "Quote not found" }, status: :not_found
      end

      def quote_params_with_defaults
        quote_params.merge({
                             contract_start_date: Date.current,
                             contract_end_date: Date.current + 1,
                             contract_type_id: nil
                           })
      end

      def quote_params
        params.require(:quote).permit(:customer_id,
                                      :total_price,
                                      :step,
                                      :contract_type_id,
                                      :contract_start_date,
                                      :contract_end_date)
      end

      def serialize_quote(quote, **options)
        QuoteSerializer.new(quote, **options).serializable_hash
      end
    end
  end
end
