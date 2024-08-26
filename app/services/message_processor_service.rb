# frozen_string_literal: true

class MessageProcessorService
  def initialize(message_sid, message_status)
    @message_sid = message_sid
    @message_status = message_status
  end

  def process
    find_message_sender
    update_message_status
    notify_user_status
    log_user_and_message_status
  end

  private

  def find_message_sender
    @user = Message.find_by(external_id: @message_sid).user
  end

  def update_message_status
    message = Message.find_by(external_id: @message_sid)
    message.update(status: @message_status)
  end

  def notify_user_status
    data = if success_notification?
             { type: 'success_notification',
               message: I18n.t('twilio.success_status_message', message_status: @message_status) }
           else
             { type: 'failure_notification',
               message: I18n.t('twilio.failure_status_message', message_status: @message_status) }
           end
    ActionCable.server.broadcast 'notification_channel', data
  end

  def success_notification?
    SUCCESS_SMS_STASTUS.include?(@message_status)
  end

  def log_user_and_message_status
    Rails.logger.debug "UserId: #{@user.id}, SID: #{@message_sid}, Status: #{@message_status}"
  end
end
