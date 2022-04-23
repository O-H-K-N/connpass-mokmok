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

  def index
    @records = params[:tag_id].present? ? Tag.find(params[:tag_id]).records : current_user.records.all.order(created_at: :desc)
  end

  def show
    @record = current_user.records.find(params[:id])
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

  def destroy
    record = current_user.records.find(params[:id])
    record.destroy!
    redirect_to records_path
  end

  private

  def record_params
    params.require(:record).permit(
      :theme,
      :content,
      tag_ids: []
    )
  end
end
