class LinebotController < ApplicationController
  skip_before_action :login_required
  protect_from_forgery :except => [:callback]

  require 'uri'
  require 'net/http'
  require 'json'
  require 'net/http'


  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      # MessageでWebhookが送られた場合
      when Line::Bot::Event::Message
        # LINEで送られてきた文書を取得
        word = event.message['text']
        # イベントの取得順選択メッセージ
        message = User.set_order(word)
        client.reply_message(event['replyToken'], message)

      # PostbackでWebhookが送られた場合
      when Line::Bot::Event::Postback
        # postbackのdataを格納
        data = event['postback']['data']
        # メッセージを送ってきたLINEユーザのuserIdを取得
        line_user_id = event['source']['userId']
        # ユーザが設定した居住地を取得
        prefecture = User.find_by(line_id: line_user_id).prefecture
        case
        # 新着順を選択した場合
        when data.include?("new_")
          message = {type: 'text', text: 'イベント探索中・・・'}
          client.push_message(line_user_id, message)
          case
          when data.include?("オンラインもくもく会")
            # オンラインともくもく会でイベントを取得(日付は本日、順序は開催が近い順)
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword=オンライン&count=100&order=2"
            events = User.get_online_events(url)
          when data.include?("居住地周辺でのもくもく会")
            # 居住地ともくもく会でイベントを取得(日付は本日、順序は開催が遠い順)
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword=#{prefecture}&count=100&order=2"
            events = User.get_events(url)
          else
            # フリーワードからイベントを取得
            dataAry = data.split("_")
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{dataAry[1]}&count=100&order=2"
            events = User.get_events(url)
          end
          events = events.reverse.compact
        # ランダムを選択した場合
        when data.include?("randam_")
          message = {type: 'text', text: 'イベント探索中・・・'}
          client.push_message(line_user_id, message)
          case
          when data.include?("オンラインもくもく会")
            # オンラインともくもく会でイベントを取得
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword=オンライン&count=100"
            events = User.get_online_events(url)
          when data.include?("居住地周辺でのもくもく会")
            # 居住地ともくもく会でイベントを取得
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword=#{prefecture}&count=100"
            events = User.get_events(url)
          else
            # フリーワードからイベントを取得
            dataAry = data.split("_")
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{dataAry[1]}&count=100"
            events = User.get_events(url)
          end
          events = events.shuffle.compact
        end

        case events.length
        # 取得したイベントの数が0のとき
        when 0
          client.reply_message(event['replyToken'], type: 'text', text: '該当するイベントが見つかりませんでした。')
        # 取得したイベントの数が5件以上のとき
        when 5..nil
          client.reply_message(event['replyToken'], [{ type: 'text', text: 'イベントが5件以上見つかりました✨'}])
          events = events.first(5)
          events.each do |event|
            message = User.set_events(event)
            client.push_message(line_user_id, message)
          end
        # 取得したイベントの数が5件未満のとき
        else
          client.reply_message(event['replyToken'], [{ type: 'text', text: "イベントが#{events.length}件見つかりました✨"}])
          events.each do |event|
            message = User.set_events(event)
            client.push_message(line_user_id, message)
          end
        end
      end
    }
    head :ok
  end

  private

  # LINE Developers登録完了後に作成される環境変数の認証
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end