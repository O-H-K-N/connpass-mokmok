class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_liff_top_id
    gon.liff_id = ENV['LIFF_TOP_ID']
  end

  def set_liff_record_id
    gon.liff_id = ENV['LIFF_RECORD_ID']
  end
end
