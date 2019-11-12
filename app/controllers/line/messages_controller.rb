# frozen_string_literal: true

module Line
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      line_client
      body = request.body.read
      events = @client.parse_events_from(body)
      line_user_id = events.first['source']['userId']

      profile = LineBotApi::GetProfile.new.execute(line_user_id: line_user_id)
      display_name = profile['displayName']
      events.each do |event|
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: "#{display_name}さん、こんにちは!!"
          }
          @client.reply_message(event['replyToken'], message)
        end
      end

      render status: :ok
    end

    private

    def line_client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_id = ENV['LINE_CHANNEL_ID']
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
    end
  end
end
