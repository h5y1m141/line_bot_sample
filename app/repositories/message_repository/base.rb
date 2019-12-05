module MessageRepository
  class Base
    attr_accessor :event, :line_user, :line_client, :reply_token
    class NotOverrideError < StandardError; end

    def initialize(event, line_user)
      @event = event
      @line_user = line_user
      @reply_token = event['replyToken']
      @line_client ||= Line::Bot::Client.new do |config|
        config.channel_id = ENV['LINE_CHANNEL_ID']
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
    end

    def create
      raise NotOverrideError
    end

    private

    def reply(message)
      line_client.reply_message(reply_token, message)
    end
  end
end
