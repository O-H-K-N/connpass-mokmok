class UsersController < ApplicationController
  require 'net/http'
  require 'uri'

  def new
    line_user_id = params[:id]
  end

  def create
    idToken = params[:idToken]
    channelId = '1657044144'
    res = Net::HTTP.post_form(
      URI.parse('https://api.line.me/oauth2/v2.1/verify'),
      {'id_token'=>idToken, 'client_id'=>channelId}
    )
    line_user_id = JSON.parse(res.body)["sub"]
  end
end
