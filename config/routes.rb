# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'sms_alerts#index'
  post :send_sms, controller: :sms_alerts, action: :send_sms, as: 'send_sms'
  post '/message-status', to: 'twilio_webhooks#message_status'
end
