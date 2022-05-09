class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[login create]
  before_action :set_liff_top_id, only: %i[login show]

  require 'net/http'
  require 'uri'

  def login; end

  def show
    # 初期設定で登録したconnpassのアカウント名から予約済みのイベントを取得
    @account = current_user.connpass.account
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
      # 新規アカウントであればConnpassのからデータを作成
      connpass = Connpass.create!
      user = User.create!(line_id: line_user_id, connpass: connpass)
      session[:user_id] = user.id
      res = { status: 'ok' }
      render json: res
    else user
      session[:user_id] = user.id
      res = { id: user.id }
      render json: res
    end
  end

  private

  # connpassAPIを叩く
  def set_connpass(account)
    url = URI.encode"https://connpass.com/api/v1/event/?nickname=#{@account}&count20&order=2"
    # インスタンスを生成
    uri = URI.parse(url)
    # リクエストを送りjson形式で受け取る
    json =  Net::HTTP.get(uri)
    return JSON.parse(json)
  end

end
