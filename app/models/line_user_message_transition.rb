class LineUserMessageTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :line_user_message, inverse_of: :line_user_message_transitions

  private
end
