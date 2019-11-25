class LineProfileRepository
  class << self
    def find_by(line_user_id:)
      LineBotApi::GetProfile.new.execute(line_user_id: line_user_id)
    end

    def create!(line_user_id:, line_display_name:)
      line_user = LineUser.find_by(line_user_id: line_user_id)
      if line_user.present?
        line_user.update!(line_display_name: line_display_name)
      else
        LineUser.create!(
          line_user_id: line_user_id,
          line_display_name: line_display_name
        )
      end
    end
  end
end
