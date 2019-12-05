class MessageStateMachine
  include Statesman::Machine

  state :accept_request, initial: true
  state :ask_visit_datetime
  state :ask_number_or_people
  state :confirm
  state :completed

  transition from: :accept_request, to: %i[ask_visit_datetime]
  transition from: :ask_visit_datetime, to: %i[ask_number_or_people]
  transition from: :confirm,      to: :completed

  # guard_transition(to: :confirm) do |message|
  #   Order.check_something(message)
  # end

  # before_transition(from: :confirm, to: :completed) do |message, _transition|
  #   message.reallocate_stock
  # end

  # before_transition(to: :completed) do |message, _transition|
  #   PaymentService.new(message).submit
  # end

  # after_transition(to: :completed) do |message, _transition|
  #   MailerService.order_confirmation(message).deliver
  # end
end
