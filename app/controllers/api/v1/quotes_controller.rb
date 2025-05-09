module Api
  module V1
    class QuotesController < BaseController
      before_action :set_quote, only: [:update]

      def create
        quote = current_user.quotes.build(quote_params)

        if quote.save
          render json: QuoteSerializer.new(quote).serializable_hash, status: :created
        else
          render json: { errors: quote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @quote.update(quote_params)
          render json: QuoteSerializer.new(@quote).serializable_hash, status: :ok
        else
          render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_quote
        @quote = current_user.quotes.find_by(id: params[:id])

        render json: { error: "Quote not found" }, status: :not_found unless @quote
      end

      def quote_params
        params.require(:quote).permit(:customer_id, :total_price, :step)
      end
    end
  end
end
