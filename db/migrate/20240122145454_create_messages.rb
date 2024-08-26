# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.string :status, null: false
      t.string :external_id, null: false

      t.timestamps
    end
  end
end
