class Book < ApplicationRecord
  has_many :rentals

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :available_copies, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def decrement_available_copy
    decrement!(:available_copies)
  end

  def increment_available_copy
    increment!(:available_copies)
  end

  delegate :decrement_available_copy, :increment_available_copy, to: :book_inventory, prefix: true

  private

  def book_inventory
    self
  end
end
