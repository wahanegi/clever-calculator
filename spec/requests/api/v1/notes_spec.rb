require 'rails_helper'

RSpec.describe "Api::V1::Notes", type: :request do
  let!(:user) { create :user }
  let!(:customer) { create :customer }
  let!(:quote) { create :quote, customer: customer, user: user }
  let!(:item) { create :item }
  let!(:quote_item) { create :quote_item, quote: quote, item: item }
  let!(:note) { create :note, quote_item: quote_item }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:json_response) { response.parsed_body }

  before { sign_in user }

  describe "POST /api/v1/quotes/:quote_id/quote_items/:quote_item_id/note/upsert" do
    context 'when updating existing note' do
      let(:update_params) do
        { note: { notes: "Updated notes", is_printable: true } }
      end

      before do
        post "/api/v1/quotes/#{quote.id}/quote_items/#{quote_item.id}/note/upsert",
             params: update_params.to_json,
             headers: headers
      end

      it "updates the note" do
        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["id"]).to eq(note.id.to_s)
        expect(note.reload.notes).to eq("Updated notes")
        expect(note.reload.is_printable).to eq(true)
      end
    end

    context 'when creating new note' do
      let!(:quote_item_without_note) { create :quote_item, quote: quote, item: item }
      let(:create_params) do
        { note: { notes: "New notes", is_printable: false } }
      end

      it "creates a new note record" do
        expect do
          puts "Existing note: #{quote_item_without_note.note.inspect}"
          post "/api/v1/quotes/#{quote.id}/quote_items/#{quote_item_without_note.id}/note/upsert",
               params: create_params.to_json,
               headers: headers
        end.to change(Note, :count).by(1)

        new_note = Note.find_by(notes: "New notes")
        expect(new_note).to be_present
        expect(new_note.is_printable).to eq(false)
        expect(json_response["data"]["attributes"]["notes"]).to eq("New notes")
      end
    end

    context 'when missing notes field' do
      let!(:quote_item_without_note) { create :quote_item, quote: quote, item: item }
      let(:invalid_params) do
        { note: { is_printable: false } }
      end

      it "does not create a new note and returns errors" do
        expect do
          post "/api/v1/quotes/#{quote.id}/quote_items/#{quote_item_without_note.id}/note/upsert",
               params: invalid_params.to_json,
               headers: headers
        end.not_to change(Note, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]["notes"]).to include("Notes can't be blank")
      end
    end

    context 'when unauthenticated' do
      before { sign_out user }

      let(:create_params) do
        { note: { notes: "New notes", is_printable: false } }
      end

      it "returns unauthorized" do
        post "/api/v1/quotes/#{quote.id}/quote_items/#{quote_item.id}/note/upsert",
             params: create_params.to_json,
             headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/quotes/:quote_id/quote_items/:quote_item_id/note" do
    before do
      delete "/api/v1/quotes/#{quote.id}/quote_items/#{quote_item.id}/note",
             headers: headers
    end

    it "deletes the note" do
      expect(response).to have_http_status(:no_content)
      expect(quote_item.reload.note).to be_nil
    end
  end
end
