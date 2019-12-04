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

      line_user = LineProfileRepository.create(
        line_user_id: line_user_id,
        line_display_name: line_display_name
      )

      events.each do |event|
        case event.type
        when Line::Bot::Event::MessageType::Text
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
              text: 'ランチかディナーどちらにしますか？'
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
          @client.reply_message(reply_token, message)
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
