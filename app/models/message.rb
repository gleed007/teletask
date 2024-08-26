# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :body, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :status, presence: true
end
