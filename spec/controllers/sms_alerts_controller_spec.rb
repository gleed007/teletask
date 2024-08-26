# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmsAlertsController do
  describe 'POST #send_sms' do
    let(:user) { create(:user, phone_number: Faker::PhoneNumber.cell_phone_in_e164) }
    let(:user_attributes) { attributes_for(:user) }

    before do
      sign_in user
    end

    let(:valid_params) { { msg: 'sms content' } }

    it 'enqueues SendSmsJob with correct parameters' do
      expect do
        post :send_sms, params: valid_params
      end.to enqueue_sidekiq_job(SendSmsJob)
    end

    it 'redirects to root_path with a notice' do
      post :send_sms, params: valid_params
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq(I18n.t('sms_alert_wait'))
    end
  end
end
