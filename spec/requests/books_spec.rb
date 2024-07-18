require 'rails_helper'

RSpec.describe BooksController, type: :request do
  let(:valid_attributes) {
    { title: "The Great Gatsby", author: "F. Scott Fitzgerald", isbn: "9780743273565", available_copies: 5 }
  }

  let(:invalid_attributes) {
    { title: "", author: "", isbn: "", available_copies: -1 }
  }

  describe "GET /index" do
    it "returns a success response" do
      Book.create! valid_attributes
      get books_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "returns a success response" do
      book = Book.create! valid_attributes
      get book_url(book)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid params" do
      it "creates a new Book" do
        expect {
          post books_url, params: { book: valid_attributes }
        }.to change(Book, :count).by(1)
      end

      it "returns a created status" do
        post books_url, params: { book: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "returns an unprocessable entity status" do
        post books_url, params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "The Great Gatsby", author: "Fitzgerald", available_copies: 10 }
      }

      it "updates the requested book" do
        book = Book.create! valid_attributes
        patch book_url(book), params: { book: new_attributes }
        book.reload
        expect(book.author).to eq("Fitzgerald")
        expect(book.available_copies).to eq(10)
      end

      it "returns an ok status" do
        book = Book.create! valid_attributes
        patch book_url(book), params: { book: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns an unprocessable entity status" do
        book = Book.create! valid_attributes
        patch book_url(book), params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested book" do
      book = Book.create! valid_attributes
      expect {
        delete book_url(book)
      }.to change(Book, :count).by(-1)
    end

    it "returns a no content status" do
      book = Book.create! valid_attributes
      delete book_url(book)
      expect(response).to have_http_status(:no_content)
    end
  end
end
