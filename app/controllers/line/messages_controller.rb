# frozen_string_literal: true

module Line
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      line_client
      body = request.body.read
      events = @client.parse_events_from(body)
      line_user_id = events.first['source']['userId']

      profile = LineProfileRepository.find_by(line_user_id: line_user_id)
      line_display_name = profile['displayName']

      LineProfileRepository.create!(
        line_user_id: line_user_id,
        line_display_name: line_display_name
      )

      events.each do |event|
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: "#{line_display_name}さん、こんにちは!!id: #{line_user_id}"
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
