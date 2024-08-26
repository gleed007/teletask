# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:valid_user_attributes) do
    {
      email: 'user@example.com',
      password: 'helloworld@1234',
      phone_number: Rails.application.credentials[:TWILIO_TO_NUMBER],
      name: 'Dummy User'
    }
  end

  it 'is valid with valid attributes' do
    user = described_class.new(valid_user_attributes)
    expect(user).to be_valid
  end

  it 'is not considered valid unless it adheres to a valid phone number format' do
    user = described_class.new(valid_user_attributes.merge(phone_number: '1234567890'))
    expect(user).not_to be_valid
    expect(user.errors[:phone_number]).to include('invalid!')
  end

  it 'initiates the execution of send_welcome_sms following the creation of a user' do
    user = described_class.create(valid_user_attributes)
    expect(user).to be_valid

    allow_any_instance_of(Twilio::SmsAlertService).to receive(:send).and_return(status: true)
    user.save
  end

  it 'Does not reverse the transaction in the case of a successful execution of send_welcome_sms.' do
    user = described_class.new(valid_user_attributes)
    allow_any_instance_of(Twilio::SmsAlertService).to receive(:send).and_return(status: true)

    expect { user.save }.to change(described_class, :count).by(1)
    expect(user.errors).to be_empty
  end
end
