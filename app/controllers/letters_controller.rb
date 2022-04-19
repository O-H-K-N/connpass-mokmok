class LettersController < ApplicationController
  skip_before_action :login_required, only: %i[login logedin]
  before_action :set_liff_letter_id, only: %i[login]
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
    @letter = current_user.letters.new
  end

  def create
    @letter = current_user.letters.new(letter_params)
    if @letter.save
      # redirect_to root_path
    else
      render :new
    end

  end

  private

  def letter_params
    params.require(:letter).permit(
      :message,
      :dig_notice
    )
  end
end
