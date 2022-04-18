class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[login]
  before_action :set_liff_top_id, only: %i[login]

  require 'net/http'
  require 'uri'

  def login;end

  def create
		# IDトークンを取得
    id_token = params[:idToken]
    # 環境変数に登録しておいたLIFF_CHANNEL_IDを取得
    channel_id = ENV['LIFF_CHANNEL_ID']
    # IDトークンを検証し、アカウント情報を取得
		res = Net::HTTP.post_form(
			URI.parse('https://api.line.me/oauth2/v2.1/verify'),
			{'id_token'=>id_token, 'client_id'=>channel_id}
		)
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)
    # 新規アカウントか既存アカウントかを検証
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