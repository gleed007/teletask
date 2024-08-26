# frozen_string_literal: true

class SmsAlertsController < ApplicationController
  before_action :authenticate_user!

  def send_sms
    SendSmsJob.perform_in(SIDEKIQ_DELAY, current_user.id, current_user.phone_number, params[:msg], current_user.name)
    redirect_back fallback_location: root_path, notice: I18n.t('sms_alert_wait')
  end
end
