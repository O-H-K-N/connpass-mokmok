class UsersController < ApplicationController
  require 'net/http'
  require 'uri'

  def new; end

  def create
    id_token = params[:idToken]
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>id_token, 'client_id'=>channel_id})
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)
    if user.nil?
      user = User.create(line_id: line_user_id)
      session[:user_id] = user.id
      render :json => user
    elsif user
      session[:user_id] = user.id
      render :json => user
    end
  end
end