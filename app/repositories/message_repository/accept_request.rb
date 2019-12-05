module MessageRepository
  class AcceptRequest < Base
    def create
      message_sequence_id ||= SecureRandom.hex(8)
      line_message = LineUserMessage.create!(
        message_sequence_id: message_sequence_id,
        line_user_id: line_user.id,
        reply_token: reply_token,
        message: event.message['text'],
        status: LineUserMessage::ACCEPT_REQUEST
      )
      line_message.state_machine.transition_to(:ask_visit_datetime)
      message = {
        type: 'text',
        text: 'ランチ or ディナー？'
      }
      reply(message)
    end
  end
end
