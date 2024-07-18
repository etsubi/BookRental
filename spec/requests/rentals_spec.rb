require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, available_copies: 5) }
  let!(:rental) { create(:rental, user: user, book: book, rented_on: Date.today) }

  describe "POST #create" do
    context "when the book is available" do
      it "creates a new rental and decreases the book's available copies by 1" do
        expect {
          post :create, params: { rental: { user_id: user.id, book_id: book.id } }
        }.to change(Rental, :count).by(1)
        expect(book.reload.available_copies).to eq(4)
        expect(response).to have_http_status(:created)
      end
    end

    context "when the book is not available" do
      before { book.update(available_copies: 0) }

      it "does not create a new rental and returns an error" do
        expect {
          post :create, params: { rental: { user_id: user.id, book_id: book.id } }
        }.not_to change(Rental, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Book not available')
      end
    end
  end

  describe "GET #show" do
    it "returns the rental details" do
      get :show, params: { id: rental.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(rental.id)
    end

    it "returns an error if rental not found" do
      get :show, params: { id: 'invalid_id' }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Record not found')
    end
  end

  describe "PUT #update" do
    context "when marking as returned" do
      it "updates the rental and increases the book's available copies by 1" do
        put :update, params: { id: rental.id, rental: { returned_on: Date.today, book_id: book.id } }
        expect(rental.reload.returned_on).to eq(Date.today)
        expect(book.reload.available_copies).to eq(6)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when update fails" do
      it "returns an error" do
        allow_any_instance_of(Rental).to receive(:update).and_return(false)
        put :update, params: { id: rental.id, rental: { returned_on: Date.today, book_id: book.id } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the rental" do
      expect {
        delete :destroy, params: { id: rental.id }
      }.to change(Rental, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns an error if rental not found" do
      delete :destroy, params: { id: 'invalid_id' }
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Record not found')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
