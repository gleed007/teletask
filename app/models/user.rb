# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :phone_number, format: { with: /\A\+\d{2}\d{9,15}\z/, message: 'invalid!' }
  validates :phone_number, uniqueness: { case_sensitive: false }
  after_commit :send_welcome_sms, on: %i[create update], if: -> { saved_change_to_phone_number? }
  has_many :messages, dependent: :destroy

  private

  def send_welcome_sms
    SendSmsJob.perform_async(id, phone_number, SIGN_UP_ALERT_TEXT, name)
  end
end
