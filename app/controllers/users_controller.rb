class UsersController < ApplicationController
  require 'net/http'
  require 'uri'

  def login; end

  def new; end

  def create
    idToken = params[:idToken]
    channelId = '1657044144'
    res = Net::HTTP.post_form(
      URI.parse('https://api.line.me/oauth2/v2.1/verify'),
      {'id_token'=>idToken, 'client_id'=>channelId}
    )
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)
    #Userにログイン情報と一致するアカウントが無いかを検証
    if user.nil? && !line_user_id.nil?
      user = User.create!(line_id: line_user_id)
      session[:user_id] = user.id
    elsif user
      session[:user_id] = user.id
    end
  end
end
