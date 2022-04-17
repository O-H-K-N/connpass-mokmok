class LinebotController < ApplicationController
  protect_from_forgery :except => [:callback]

  def callback
    # リクエストのヘッダー署名情報を取得
    body = request.body.read
    # 署名検証
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    # リクエストボディのみ取得
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      # MessageでWebhookが送られた場合
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # ユーザを特定
          @user = User.find_by(line_id: event['source']['userId'])
          if @user.nil?
            message = {
              type: 'text',
              text: 'メニューバーからユーザ登録を行ってください'
            }
            client.reply_message(event['replyToken'], message)
          end
          # 送られてきたメッセージを格納
          replied_message = event.message['text']

          # 手紙を登録するやりとりをステータスごとに分けて処理
          case @user.letter_status
          # 手紙の内容（メッセージ）を送ってくるようにアナウンスする処理
          when 'send_message'
            if replied_message == '手紙'
              message = {
                type: 'text',
                text: '未来の自分に向けてのメッセージを送ろう！'
              }
              client.reply_message(event['replyToken'], message)
              @user.message_registration!
            else
              message = {
                type: 'text',
                text: 'メニューバーから「手紙」「記録」を選択して、未来の自分にメッセージを送ろう！'
              }
              client.reply_message(event['replyToken'], message)
            end
          # 表示されたアクションを選択せずに、メッセージが送られたときの処理
          when 'message_registration'
            now = Date.today
            min = now >> 1
            max = now >> 12
            @letter = Letter.create(user_id: @user.id, message: replied_message, dig_notice: max)
            message = {
              type: 'text',
              text: "１ヶ月後から１年後までの間で、手紙を届ける日時を選択しよう！",
              quickReply: {
                items: [
                  {
                    type: 'action',
                    action: {
                      type: "datetimepicker",
                      label: "こちらから日時を選択してください",
                      data:  @letter.id,
                      mode: "date",
                      initial: min.strftime("%Y-%m-%d"),
                      max: max.strftime("%Y-%m-%d"),
                      min: min.strftime("%Y-%m-%d")
                    }
                  }
                ]
              }
            }
            client.reply_message(event['replyToken'], message)
            @user.dig_registration!
          end
        end
      # PostbackでWebhookが送られた場合
      when Line::Bot::Event::Postback
        @user = User.find_by(line_id: event['source']['userId'])

        case  @user.letter_status
        # 登録されたデータの内容を表示する処理
        when 'dig_registration'
          @letter = Letter.find_by(id: event['postback']['data'])
          @letter.update(dig_notice: event['postback']['params']['date'].to_date)
          message = {
            type: 'text',
            text: "登録したよ！\n\n登録した手紙は\n"+ @letter.dig_notice.strftime("%Y年%-m月%-d日") +"に届くよ！\n\nお楽しみに！"
          }
          client.reply_message(event['replyToken'], message)
          @user.send_message!
        end
      end
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