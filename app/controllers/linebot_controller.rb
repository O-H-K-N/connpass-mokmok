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
        # メッセージを送ってきたLINEユーザのuserIdを取得
        line_user_id = event['source']['userId']
      end

      prefecture = User.find_by(line_id: line_user_id).prefecture

      case word
      when 'オンラインもくもく会'
        # オンラインともくもく会でイベントを取得(日付は本日、順序は開催が遠い順)
        url = URI.encode"https://connpass.com/api/v1/event/?keyword=オンライン　もくもく会&count=100&order=1"
      when '居住地周辺でのもくもく会'
        # 居住地ともくもく会でイベントを取得(日付は本日、順序は開催が遠い順)
        url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{prefecture}&keyword=もくもく会&count=100&order=1"
      else
        # 送られてきたキーワードでイベントを取得(日付は本日、順序は開催が遠い順)
        url = URI.encode"https://connpass.com/api/v1/event/?keyword=#{word}&count=100&order=1"
      end

      # インスタンスを生成
      uri = URI.parse(url)
      # リクエストを送りjson形式で受け取る
      json =  Net::HTTP.get(uri)
      # ハッシュ形式に返還
      data = JSON.parse(json)

      # 開催前のイベントを抽出
      events = data["events"].map do |event|
        if event["ended_at"] > DateTime.now
          event
        else
          next
        end
      end
      # 配列内のnilを削除しシャッフルして並べ直す
      events = events.shuffle.compact

      case event
      # メッセージが送信された場合
      when Line::Bot::Event::Message
        case event.type
        # メッセージが送られて来た場合
        when Line::Bot::Event::MessageType::Text
          case events.length
          # 取得したイベントの数が0のとき
          when 0
            client.reply_message(event['replyToken'], type: 'text', text: '該当するイベントが見つかりませんでした。')
          # 取得したイベントの数が1のとき
          when 1
            client.reply_message(event['replyToken'],
              [
                {
                  type: 'text',
                  text: events[0]["title"] + "\n\n" + events[0]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜") + "\n\n" + events[0]["event_url"]
                }
              ]
            )
          # 取得したイベントの数が2のとき
          when 2
            client.reply_message(event['replyToken'],
              [
                {
                  type: 'text',
                  text: events[0]["title"] + "\n\n" + events[0]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜") + "\n\n" + events[0]["event_url"]
                },
                {
                  type: 'text',
                  text: events[1]["title"] + "\n\n" + events[1]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜") + "\n\n" + events[1]["event_url"]
                }
              ]
            )
          # 取得したイベントの数が3以上のとき
          when 3..
            client.reply_message(event['replyToken'],
              [
                {
                  type: 'text',
                  text: events[0]["title"] + "\n\n" + events[0]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜") + "\n\n" + events[0]["event_url"]
                },
                {
                  type: 'text',
                  text: events[1]["title"] + "\n\n" + events[1]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜") + "\n\n" + events[1]["event_url"]
                },
                {
                  type: 'text',
                  text: events[2]["title"] + "\n\n" + events[2]["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜")+ "\n\n" + events[2]["event_url"]
                }
              ]
            )
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