class AddForeginKeyToOrderTransactions < ActiveRecord::Migration[5.2]
  def change
    add_index(:order_transitions,
              %i[order_id sort_key],
              unique: true,
              name: 'index_order_transitions_parent_sort')
    add_index(:order_transitions,
              %i[order_id most_recent],
              unique: true,

              name: 'index_order_transitions_parent_most_recent')
  end
end
