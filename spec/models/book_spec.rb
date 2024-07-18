require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { 
    described_class.new(
      title: "Some Book", 
      author: "Some Author", 
      isbn: 1234567890, 
      available_copies: 10
    ) 
  }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:isbn) }
  it { should validate_presence_of(:available_copies) }

  # it { should validate_numericality_of(:isbn).only_integer }
  it { should validate_numericality_of(:available_copies).only_integer }
  it { should validate_numericality_of(:available_copies).is_greater_than_or_equal_to(0) }

  it "validates that :available_copies cannot be empty" do
    subject.available_copies = nil
    expect(subject).not_to be_valid
    expect(subject.errors[:available_copies]).to include("can't be blank")
  end
end
