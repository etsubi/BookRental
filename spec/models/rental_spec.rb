require 'rails_helper'

RSpec.describe Rental, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:book) }
  it { should validate_presence_of(:rented_on) }

  describe "validations" do
    it "is valid with valid attributes" do
      rental = build(:rental)
      expect(rental).to be_valid
    end

    it "is not valid without a rented_on date" do
      rental = build(:rental, rented_on: nil)
      expect(rental).not_to be_valid
    end

    it "is not valid if returned_on is before rented_on" do
      rental = build(:rental, rented_on: DateTime.now, returned_on: DateTime.now - 1.day)
      expect(rental).not_to be_valid
      expect(rental.errors[:returned_on]).to include("must be after the rented on date")
    end
  end
end
