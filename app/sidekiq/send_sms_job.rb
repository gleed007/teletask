# frozen_string_literal: true

class SendSmsJob
  include Sidekiq::Job

  def perform(user_id, phone_number, msg, name)
    Twilio::SmsAlertService.new(user_id, phone_number, msg, name).send
  end
end
