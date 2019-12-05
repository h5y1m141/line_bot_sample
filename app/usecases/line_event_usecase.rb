class LineEventUsecase
  attr_accessor :events, :line_user, :line_display_name

  def initialize(events)
    @events = events
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
    MessageRepository::ReplyMessage.new(event, line_user).execute
  end

  def handle_postback(event)
  end
end
