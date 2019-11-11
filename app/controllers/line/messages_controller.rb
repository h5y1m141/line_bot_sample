# frozen_string_literal: true

module Line
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      line_client
      event = params['message']['events'].first
      message = {
        type: 'text',
        text: 'こんにちは'
      }
      @client.reply_message(event['replyToken'], message)
      render status: 200, json: { status: 200, message: 'Success' }
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
