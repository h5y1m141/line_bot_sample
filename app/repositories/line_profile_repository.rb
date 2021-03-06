class LineProfileRepository
  class << self
    def fetch_profile(line_user_id:)
      LineBotApi::GetProfile.new.execute(line_user_id: line_user_id)
    end

    def find_by(line_user_id:, line_display_name:)
      line_user = LineUser.find_by(line_user_id: line_user_id)
      if line_user.present?
        line_user.update(line_display_name: line_display_name)
      else
        line_user = LineUser.create(
          line_user_id: line_user_id,
          line_display_name: line_display_name
        )
      end
      line_user
    end
  end
end
