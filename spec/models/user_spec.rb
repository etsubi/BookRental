require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  
  it "validates uniqueness of email case-insensitively" do
    create(:user, email: "test@example.com")
    should validate_uniqueness_of(:email).case_insensitive
  end

  it { should validate_length_of(:password).is_at_least(8) }
  it { should allow_value('user@example.com').for(:email) }
  it { should_not allow_value('userexample.com').for(:email) }

  describe "callbacks" do
    it "downcases the email before saving" do
      user = build(:user, email: "Foo@ExAMPle.CoM")
      user.save
      expect(user.reload.email).to eq("foo@example.com")
    end
  end
end
