module MessageRepository
  class ReplyMessage
    attr_accessor :reservation_request, :event, :line_user

    def initialize(event, line_user)
      @event = event
      @line_user = line_user
      @reservation_request = [
        {
          regex: /.*予約/,
          klass: MessageRepository::AcceptRequest
        },
        {
          regex: /.*ランチ|ディナー/,
          klass: MessageRepository::AskVisitDatetime
        }
      ].freeze
    end

    def execute
      matches = reservation_request.select { |v| event.message['text'] =~ v[:regex] }

      if matches.blank?
        MessageRepository::NotAcceptable.new(event, line_user).create
      else
        matches.first[:klass].new(event, line_user).create
      end
    end
  end
end
