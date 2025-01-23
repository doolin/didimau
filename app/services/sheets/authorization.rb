module Sheets
  class Authorization
    BASE_AUTH_URL="https://accounts.google.com/o/oauth2/auth"
    BASE_TOKEN_URL="https://oauth2.googleapis.com/token"

    def initialize(client_id, client_secret, redirect_uri)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
    end

    def get_auth_url
      "#{BASE_AUTH_URL}?client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&response_type=code&scope=https://www.googleapis.com/auth/spreadsheets"
    end

    def get_token(code)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @redirect_uri,
        code: code,
        grant_type: "authorization_code"
      })
      JSON.parse(response.body)
    end

    def refresh_token(refresh_token)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        client_id: @client_id,
        client_secret: @client_secret,
        refresh_token: refresh_token,
        grant_type: "refresh_token"
      })
      JSON.parse(response.body)
    end

    def revoke_token(token)
      response = HTTParty.post(BASE_TOKEN_URL, body: {
        token: token,
        client_id: @client_id,
        client_secret: @client_secret
      })
      JSON.parse(response.body)
    end
  end
end
