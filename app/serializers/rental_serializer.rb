class RentalSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :book_id, :rented_on, :returned_on

  belongs_to :book
  belongs_to :user
end
