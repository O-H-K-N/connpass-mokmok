class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[login set create]
  before_action :set_liff_top_id, only: %i[login]
  before_action :set_liff_keyword_id, only: %i[set]

  require 'net/http'
  require 'uri'

  # 「予約イベントを確認」からのログイン
  def login; end

  # 「キーワードに関するもくもく会一覧」からのログイン
  def set; end

  def events
    # ユーザが登録したキーワードに関するもくもく会を取得
    url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword_or=#{current_user.word_first}&keyword_or=#{current_user.word_second}&keyword_or=#{current_user.word_third}&count=100&order=2"
    events = User.get_events(url)
    @events = events.reverse.compact
  end

  def show
    # 初期設定で登録したconnpassのアカウント名から予約済みのイベントを取得
    @account = current_user.account
    # 初期設定で登録した予約イベントの表示数を取得
    @count = current_user.count
    # ユーザに紐づくイベントを取得
    data = set_connpass(@account)
    # 開催前のイベントを収集
    before_events = data["events"].map do |event|
      if event["ended_at"] > DateTime.now
        event
      else
        next
      end
    end
    # 開催後のイベントを収集
    after_events = data["events"].map do |event|
      if event["ended_at"] < DateTime.now
        event
      else
        next
      end
    end
    # 配列内のnilを削除し逆順に並べ直す
    @before_events = before_events.reverse.compact
    # 配列内のnilを削除
    @after_events = after_events.compact
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    # IDトークンからアカウント情報を取得
    line_user_id = set_line_user(params[:idToken])
    @user = User.find_by(line_id: line_user_id)
    if @user.nil?
      @user = User.create(line_id: line_user_id)
      session[:user_id] = @user.id
      res = { status: 'ok', id: @user.id }
      render json: res
    else @user
      session[:user_id] = @user.id
      # ユーザ情報が未設定の場合、ユーザ設定ページに遷移
      if current_user.flag == false
        res = { status: 'ok', id: @user.id }
        render json: res
      else
        res = { id: @user.id }
        render json: res
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # リッチメニュー切り替え処理（初回更新時のみ）
      if @user.flag == false
        # リッチメニューの切り替え
        set_richmenu(@user)
        @user.update(flag: true)
      end
      redirect_to edit_user_path(@user), success: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    client = User.line_client
    client.unlink_user_rich_menu(@user.line_id)
    @user.destroy
    redirect_to close_path
  end

  private

  # アクセスしたLINEアカウント情報の取得
  def set_line_user(id_token)
    # 環境変数に登録しておいたLIFF_CHANNEL_IDを取得
    channel_id = ENV['LIFF_CHANNEL_ID']
    # IDトークンを検証し、アカウント情報を取得
		res = Net::HTTP.post_form(
			URI.parse('https://api.line.me/oauth2/v2.1/verify'),
			{'id_token'=>id_token, 'client_id'=>channel_id}
		)
    return JSON.parse(res.body)["sub"]
  end

  # connpassAPIを叩く
  def set_connpass(account)
    url = URI.encode"https://connpass.com/api/v1/event/?nickname=#{@account}&count=#{@count}&order=2"
    # インスタンスを生成
    uri = URI.parse(url)
    # リクエストを送りjson形式で受け取る
    json =  Net::HTTP.get(uri)
    return JSON.parse(json)
  end

  # リッチメニュー切り替え処理
  def set_richmenu(user)
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
  end

  def user_params
    params.require(:user).permit(
      :line_id,
      :account,
      :prefecture,
      :word_first,
      :word_second,
      :word_third,
      :count,
      :checked
    )
  end

end
