class RecordsController < ApplicationController
  skip_before_action :login_required, only: %i[login logedin]
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

  def show
    @record = Record.find(params[:id])
  end

  def new
    @record = current_user.records.new
  end

  def create
    @record = current_user.records.new(record_params)
    if @record.save
      redirect_to record_path(@record)
    else
      render :new
    end
  end

  private

  def record_params
    params.require(:record).permit(
      :category,
      :title,
      :content
    )
  end
end
