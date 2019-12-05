class CreateLineUserMessageTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :line_user_message_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.references :line_user_message, foreign_key: true
      t.boolean :most_recent

      t.timestamps null: false
    end
  end
end
