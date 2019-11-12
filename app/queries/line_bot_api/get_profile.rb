module LineBotApi
  class GetProfile < LineBotApi::Base
    def execute(line_user_id:)
      response = client.get_profile(line_user_id)
      JSON.parse(response.read_body)
    end
  end
end
