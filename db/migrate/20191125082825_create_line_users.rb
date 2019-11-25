class CreateLineUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :line_users do |t|
      t.string :line_user_id, null: false
      t.string :line_display_name, null: false

      t.timestamps

      t.index :line_user_id, unique: true
    end
  end
end
