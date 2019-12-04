class CreateLineUserMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :line_user_messages do |t|
      t.string :message_sequence_id, comment: '一連の問い合わせを特定するために利用するID'
      t.string :reply_token, null: false
      t.references :line_user, foreign_key: true
      t.integer :status, null: false
      t.text :message, null: false

      t.timestamps

      t.index :message_sequence_id
      t.index :reply_token
    end
  end
end
