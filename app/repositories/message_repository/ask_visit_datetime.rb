module MessageRepository
  class AskVisitDatetime < Base
    def create
      line_message = LineUserMessage.where(
        line_user_id: line_user.id,
        status: LineUserMessage::ACCEPT_REQUEST
      ).last
      LineUserMessage.create!(
        message_sequence_id: line_message.message_sequence_id,
        line_user_id: line_user.id,
        reply_token: reply_token,
        message: event.message['text'],
        status: LineUserMessage::ASK_VISIT_DATETIME
      )
      line_message.state_machine.transition_to(:ask_number_or_people)
      message = {
        type: 'text',
        text: 'それでは次に人数を教えて下さい'
      }
      reply(message)
    end
  end
end
