# frozen_string_literal: true

module Twilio
  class SmsAlertService
    attr_reader :message, :contact, :client, :twilio_sender

    def initialize(user_id, contact, message, name)
      @contact = contact
      @message = "Hey #{name}, #{message}"
      @client = Twilio::REST::Client.new
      @twilio_sender = Rails.application.credentials[:TWILIO_FROM_SENDER]
      @user = User.find_by(id: user_id)
    end

    def send
      message_sid = client.messages.create(
        body: message, from: twilio_sender, to: contact,
        status_callback: Rails.application.credentials[:TWILIO_CALLBACK_URL]
      )
      @user.messages.create(body: message, external_id: message_sid.sid, status: DEFAULT_STATUS)
      { status: client.http_client.last_response.status_code == 201 }
    rescue Twilio::REST::RestError => e
      handle_twilio_rest_error(e)
    end

    private

    def handle_twilio_rest_error(error)
      { 
        status: false,
        msg: (
          if error.code == 21_211
            I18n.t('twilio.invalid_phone')
          else
            I18n.t('twilio.error', error_message: error.message)
          end
        ) 
      }
    end
  end
end
