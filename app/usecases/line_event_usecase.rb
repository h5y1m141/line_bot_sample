class LineEventUsecase
  attr_accessor :events, :line_client, :line_user, :line_display_name

  def initialize(events, line_client)
    @events = events
    @line_client = line_client
    line_user_id = events.first['source']['userId']
    profile = LineProfileRepository.fetch_profile(line_user_id: line_user_id)
    @line_display_name = profile['displayName']

    @line_user = LineProfileRepository.find_by(
      line_user_id: line_user_id,
      line_display_name: line_display_name
    )
  end

  def execute

    events.each do |event|
      case event.type
      when Line::Bot::Event::MessageType::Text then handle_message(event)
      when Line::Bot::Event::Postback then handle_postback(event)
      end
    end
  end

  private

  def handle_message(event)
    reply_token = event['replyToken']
    message_sequence_id ||= SecureRandom.hex(8)
    if event.message['text'].match(/.*予約/).present?
      line_message = LineUserMessage.create!(
        message_sequence_id: message_sequence_id,
        line_user_id: line_user.id,
        reply_token: reply_token,
        message: event.message['text'],
        status: LineUserMessage::ACCEPT_REQUEST
      )
      message = {
        type: 'text',
        text: 'ランチ or ディナー？'
      }
    elsif event.message['text'].match(/.*ランチ|ディナー/).present?
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
      message = {
        type: 'text',
        text: "それでは次に人数を教えて下さい"
      }
    else
      message = {
        type: 'text',
        text: "#{line_display_name}さん、申し訳ありませんがそのような内容は受付られません。"
      }
    end
    line_client.reply_message(reply_token, message)
  end

  def handle_postback(event)
  end
end
