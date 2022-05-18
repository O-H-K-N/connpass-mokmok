class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  helper_method :current_user
  before_action :login_required

  private

  # 未ログインの場合、トップページに遷移する
  def login_required
    redirect_to root_path unless current_user
  end

  # ログイン中のユーザをcurrent_userとして扱える
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  def set_liff_top_id
    gon.liff_id = ENV['LIFF_TOP_ID']
  end

  def set_liff_keyword_id
    gon.liff_id = ENV['LIFF_KEYWORD_ID']
  end
end
