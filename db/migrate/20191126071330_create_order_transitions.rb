class CreateOrderTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :order_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.references :order, foreign_key: true
      t.boolean :most_recent

      t.timestamps null: false
    end
  end
end
