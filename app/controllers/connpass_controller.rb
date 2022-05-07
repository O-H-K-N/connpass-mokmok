class ConnpassController < ApplicationController
  before_action :set_user, only: %i[new update]

  def new
    @connpass = @user.connpass
  end

  def update
    @connpass = Connpass.find(params[:id])
    if @connpass.update(connpass_params)
      # 新規ログイン完了後は、通常盤のリッチメニューを切り替える
      uri = URI.parse("https://api.line.me/v2/bot/user/#{@user.line_id}/richmenu/#{ENV['RICH_MENU_ID_LOGGED_IN']}")
      http = Net::HTTP.new(uri.host, uri.port)
      # リッチメニューがなければエラー発生
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri)
      # チャネルアクセストークン設定
      req['Authorization'] = "Bearer {#{ENV['LINE_CHANNEL_TOKEN']}}"
      res = http.request(req)
      res.value
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  private

  def connpass_params
    params.require(:connpass).permit(:account)
  end

  def set_user
    @user = current_user
  end
end
