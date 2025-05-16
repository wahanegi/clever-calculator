module Api
  module V1
    class NotesController < BaseController
      before_action :set_quote, only: %i[upsert destroy]
      before_action :set_quote_item, only: %i[upsert destroy]

      def upsert
        note = @quote_item.note || @quote_item.build_note(quote: @quote)

        if note.update(note_params)
          render json: NoteSerializer.new(note).serializable_hash, status: :ok
        else
          render json: ErrorSerializer.new(note.errors).serializable_hash, status: :unprocessable_entity
        end
      end

      def destroy
        note = @quote_item.note
        if note&.destroy
          head :no_content
        else
          render json: ErrorSerializer.new(note&.errors || { note: ['not found'] }).serializable_hash,
                 status: :unprocessable_entity
        end
      end

      private

      def note_params
        params.expect(note: [:notes, :is_printable])
      end

      def set_quote
        @quote = Quote.find_by(id: params[:quote_id])
        return if @quote

        render json: { error: "Quote not found with ID #{params[:quote_id]}" }, status: :not_found
      end

      def set_quote_item
        @quote_item = @quote.quote_items.find_by(id: params[:quote_item_id])
        return if @quote_item

        render json: { error: "QuoteItem not found with ID #{params[:quote_item_id]} for Quote ID #{@quote.id}" },
               status: :not_found
      end
    end
  end
end
