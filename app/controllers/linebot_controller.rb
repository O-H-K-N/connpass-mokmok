class LinebotController < ApplicationController
  protect_from_forgery :except => [:callback]
  require 'line/bot'


  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)

    # evnets内のtypeを識別していく。
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        # 今回はメッセージに対応する処理を行うため、type: "text"の場合処理をする。
        # 例えば位置情報に対応する処理を行うためには、MessageType::Locationとなる。
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            #送られた内容をそのまま返す
            text: event.message['text']
          }
        end
      end
      # 応答メッセージを送る
      client.reply_message(event['replyToken'], message)
    end
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