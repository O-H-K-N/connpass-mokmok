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
          case
          when data.include?("オンラインもくもく会")
            # オンラインともくもく会でイベントを取得(日付は本日、順序は開催が近い順)
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=オンライン　もくもく会&count=100&order=2"
          when data.include?("居住地周辺でのもくもく会")
            # 居住地ともくもく会でイベントを取得(日付は本日、順序は開催が遠い順)
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{prefecture}&keyword=もくもく会&count=100&order=2"
          else
            # フリーワードからイベントを取得
            dataAry = data.split("_")
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{dataAry[1]}&count=100&order=2"
          end
          events = User.get_events(url)
          events = events.reverse.compact
        # ランダムを選択した場合
        when data.include?("randam_")
          case
          when data.include?("オンラインもくもく会")
            # オンラインともくもく会でイベントを取得
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=オンライン　もくもく会&count=100"
          when data.include?("居住地周辺でのもくもく会")
            # 居住地ともくもく会でイベントを取得
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{prefecture}&keyword=もくもく会&count=100"
          else
            # フリーワードからイベントを取得
            dataAry = data.split("_")
            url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{dataAry[1]}&count=100"
          end
          events = User.get_events(url)
          events = events.shuffle.compact
        end

        case events.length
        # 取得したイベントの数が0のとき
        when 0
          client.reply_message(event['replyToken'], type: 'text', text: '該当するイベントが見つかりませんでした。')
        # 取得したイベントの数が1のとき
        when 1
          message = User.set_events(events[0])
          client.reply_message(event['replyToken'], [{ type: 'text', text: 'イベントは１件あります。'}, message])
        # 取得したイベントの数が2のとき
        when 2
          message_1 = User.set_events(events[0])
          message_2 = User.set_events(events[1])
          client.reply_message(event['replyToken'], [{ type: 'text', text: 'イベントは２件あります。'}, message_1, message_2])
        # 取得したイベントの数が3のとき
        when 3
          message_1 = User.set_events(events[0])
          message_2 = User.set_events(events[1])
          message_3 = User.set_events(events[2])
          client.reply_message(event['replyToken'], [{ type: 'text', text: 'イベントは３件あります。'}, message_1, message_2, message_3])
        # 取得したイベントの数が4以上のとき
        when 4..nil
          message_1 = User.set_events(events[0])
          message_2 = User.set_events(events[1])
          message_3 = User.set_events(events[2])
          message_4 = User.set_events(events[3])
          client.reply_message(event['replyToken'], [{ type: 'text', text: 'イベントは４件以上あります。'}, message_1, message_2, message_3, message_4])
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