# frozen_string_literal: true

class TwilioWebhooksController < ApplicationController
  protect_from_forgery with: :null_session

  def message_status
    NotifySmsStatusJob.perform_in(SIDEKIQ_DELAY, params[:MessageSid], params[:MessageStatus])
    redirect_back fallback_location: root_path
  end
end
