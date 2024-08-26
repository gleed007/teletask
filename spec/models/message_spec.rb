require 'rails_helper'

RSpec.describe Message do
  let(:user) { FactoryBot.create(:user, phone_number: Rails.application.credentials[:TWILIO_TO_NUMBER]) }

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:external_id) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'creation' do
    it 'is valid with valid attributes' do
      message = FactoryBot.build(:message, user: user)
      expect(message).to be_valid
    end

    it 'is invalid without a user' do
      message = FactoryBot.build(:message, user: nil)
      expect(message).to_not be_valid
    end

    it 'is invalid without a body' do
      message = FactoryBot.build(:message, body: nil, user: user)
      expect(message).to_not be_valid
    end

    it 'is invalid without an external_id' do
      message = FactoryBot.build(:message, external_id: nil, user: user)
      expect(message).to_not be_valid
    end

    it 'is invalid with a duplicate external_id' do
      existing_message = FactoryBot.create(:message, user: user)
      message = FactoryBot.build(:message, external_id: existing_message.external_id, user: user)
      expect(message).to_not be_valid
    end

    it 'is invalid without a status' do
      message = FactoryBot.build(:message, status: nil, user: user)
      expect(message).to_not be_valid
    end
  end
end
