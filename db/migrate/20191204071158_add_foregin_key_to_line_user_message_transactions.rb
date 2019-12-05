class AddForeginKeyToLineUserMessageTransactions < ActiveRecord::Migration[5.2]
  def change
    add_index(:line_user_message_transitions,
              %i[line_user_message_id sort_key],
              unique: true,
              name: 'index_line_user_message_transitions_parent_sort')
    add_index(:line_user_message_transitions,
              %i[line_user_message_id most_recent],
              unique: true,

              name: 'index_line_user_message_transitions_parent_most_recent')
  end
end
