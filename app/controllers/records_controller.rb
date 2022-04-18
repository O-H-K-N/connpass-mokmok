class RecordsController < ApplicationController
  before_action :set_liff_record_id, only: %i[login]
  require 'net/http'
  require 'uri'

  def login;end

  def logedin
    id_token = params[:idToken]
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(
			URI.parse('https://api.line.me/oauth2/v2.1/verify'),
			{'id_token'=>id_token, 'client_id'=>channel_id}
		)
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)
    session[:user_id] = user.id
  end

  def new
    @user = User.find(session[:user_id])
  end

end
