lass RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :update, :destroy]
  before_action :set_book, only: [:create, :update]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    ActiveRecord::Base.transaction do
      if @book.available_copies > 0
        @rental = Rental.new(rental_params)
        @rental.rented_on = Date.today

        @book.decrement_available_copy

        if @rental.save
          render json: @rental, status: :created
        else
          raise ActiveRecord::Rollback
        end
      else
        render json: { error: 'Book not available' }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: @rental.errors, status: :unprocessable_entity
  end

  def show
    render json: @rental
  end

  def update
    ActiveRecord::Base.transaction do
      if @rental.update(rental_params)
        @book.increment_available_copy if rental_params[:returned_on]
        render json: @rental
      else
        render json: @rental.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: @rental.errors, status: :unprocessable_entity
  end

  def destroy
    @rental.destroy
    head :no_content
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def set_book
    @book = Book.find(rental_params[:book_id])
  end

  def rental_params
    params.require(:rental).permit(:user_id, :book_id, :rented_on, :returned_on)
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
end
