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
      if event.message['text'] != nil
        # LINEで送られてきた文書を取得
        word = event.message['text']
      end

      # 送られてきたキーワードをURLに組み込む(日付は本日、順序は開催が遠い順)
      url = URI.encode"https://connpass.com/api/v1/event/?ymd=#{DateTime.now.strftime("%Y%m%d")}&keyword=#{word}&count=100&order=2"
      # インスタンスを生成
      uri = URI.parse(url)
      # リクエストを送りjson形式で受け取る
      json =  Net::HTTP.get(uri)
      # ハッシュ形式に返還
      data = JSON.parse(json)
      # data["events"].map! do |event|
      #   if event["place"] == 'オンライン' && event["started_at"] == DateTime.now
      #     event
      #   end
      # end

      res = data["events"][0]


      case event
      # メッセージが送信された場合
      when Line::Bot::Event::Message
        case event.type
        # メッセージが送られて来た場合
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: res["title"] + "\n\n" + "【概要】" + "\n" + ApplicationController.helpers.strip_tags(res["description"]) + "\n" + "開催日時" + "\n" + res["started_at"].to_date.strftime("%-m月%-d日%-H時%m分") + "\n" + "終了日時" + "\n" + res["ended_at"].to_date.strftime("%-m月%-d日%-H時%m分") + "\n" + "\n" + res["event_url"]
          }
          client.reply_message(event['replyToken'], message)
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