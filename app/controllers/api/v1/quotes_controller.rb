module Api
  module V1
    class QuotesController < BaseController
      before_action :set_quote, only: %i[update destroy reset generate_file]

      def create
        quote = current_user.quotes.build(quote_params)

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
        file = QuoteDocxGenerator.new(@quote).call

        send_file file.path, type: Mime[:docx], disposition: 'attachment', filename: "quote_#{@quote.id}.docx"
      end

      def reset
        @quote.quote_items.destroy_all

        render json: serialize_quote(@quote), status: :ok
      end

      def destroy
        @quote.destroy

        head :no_content
      end

      private

      def set_quote
        @quote = current_user.quotes.find_by(id: params[:id])

        render json: { error: "Quote not found" }, status: :not_found unless @quote
      end

      def quote_params
        params.require(:quote).permit(:customer_id, :total_price, :step)
      end

      def serialize_quote(quote, **options)
        QuoteSerializer.new(quote, **options).serializable_hash
      end
    end
  end
end
