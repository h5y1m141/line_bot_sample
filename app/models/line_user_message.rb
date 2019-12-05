class LineUserMessage < ApplicationRecord
  ACCEPT_REQUEST = 0
  ASK_VISIT_DATETIME = 1
  ASK_NUMBER_OR_PEOPLE = 2
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: LineUserMessageTransition,
    initial_state: :accept_request
  ]

  has_many :line_user_message_transitions, autosave: false
  # Initialize the state machine
  def state_machine
    @state_machine ||= MessageStateMachine.new(self, transition_class: LineUserMessageTransition,
                                                     association_name: :line_user_message_transitions)
  end

  # Optionally delegate some methods

  delegate :can_transition_to?, :current_state, :history, :last_transition,
           :transition_to!, :transition_to, :in_state?, to: :state_machine
end
