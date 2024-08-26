# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Twilio::SmsAlertService do
  let(:user) { FactoryBot.create(:user, phone_number: Faker::PhoneNumber.cell_phone_in_e164) }
  let(:message) { SUCCESS_MESSAGE }

  describe '#send' do
    context 'when Twilio API call is successful' do
      before do
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages, :create).and_return(double('double', sid: 'fake_sid'))
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:http_client, :last_response,
                                                                             :status_code).and_return(201)
      end

      it 'sends a message using Twilio' do
        expect(described_class.new(user.id, user.phone_number, message, user.name).send).to eq({ status: true })
      end
    end

    context 'when Twilio API call raises a RestError' do
      before do
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages, :create).and_raise(
          Twilio::REST::RestError.new('Test error',  double(status_code: 500, body: {}))
        )
      end

      it 'handles the error and returns a failure status with an error message' do
        expect(described_class.new(user.id, user.phone_number, message,
                                   user.name).send).to eq(status: false,
                                                     msg: "Twilio Error: ([HTTP 500] 500 : Test error\n\n)")
      end
    end

    context 'when Twilio API request raises a Twilio::REST::RestError with invalid phone number error' do
      before do
        allow_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages, :create).and_raise(
          Twilio::REST::RestError.new('Test error',  double(status_code: 21_211, body: {}))
        )
      end

      it 'returns a failure status with a specific error message' do
        expect(described_class.new(user.id, user.phone_number, message, user.name).send).to eq(status: false, msg: 'Phone number is invalid!')
      end
    end
  end
end
