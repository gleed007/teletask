# frozen_string_literal: true

class NotifySmsStatusJob
  include Sidekiq::Job

  def perform(message_id, message_status)
    processor = MessageProcessorService.new(message_id, message_status)
    processor.process
  end
end
