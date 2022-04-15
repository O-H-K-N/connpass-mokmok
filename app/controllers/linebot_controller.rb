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
          # 手紙を登録する前にnewでインスタンスに格納しておく
          if @user.letter_status == 'before_message_registration'
            @letter = Letter.new(user_id: @user.id, message: replied_message, dig: 0)
          end

          # 手紙を登録するやりとりをステータスごとに分けて処理
          case @user.letter_status
          # 手紙の内容（メッセージ）を送ってくるようにアナウンスする処理
          when 'send_message'
            if replied_message == '手紙'
              message = {
                type: 'text',
                text: '未来の自分に向けてのメッセージを送ってください'
              }
              client.reply_message(event['replyToken'], message)
              @user.before_message_registration!
            else
              message = {
                type: 'text',
                text: 'メニューバーから「手紙」「記録」を選択して、未来の自分にメッセージを送ろう'
              }
              client.reply_message(event['replyToken'], message)
            end
          # メッセージを登録する前に内容が正確かを確認する処理
          when 'before_message_registration'
            message = {
              type: 'text',
              text: "以下のメッセージで登録してよろしいですか？\n\n"+ replied_message,
              quickReply: {
                items: [
                  {
                    type: 'action',
                    action: {
                      type: "postback",
                      label: "はい",
                      data: replied_message,
                    },
                  },
                  {
                    type: 'action',
                    action: {
                      type: "postback",
                      label: "いいえ",
                      data: "rEsTaRt",
                    }
                  }
                ]
              }
            }
            client.reply_message(event['replyToken'], message)
            @user.message_registration!
          # 表示されたアクションを選択せずに、メッセージが送られたときの処理
          when 'message_registration'
            message = {
              type: "text",
              text: "再度、未来の自分に向けてのメッセージを送ってください"
            }
            client.reply_message(event['replyToken'], message)
            @user.before_message_registration!
          # 登録されたデータの内容を表示する処理
          when 'dig_registration'
            message = {
              type: 'text',
              text: "「手紙」を登録しました！\n\n手紙は○○に届きます。"
            }
            client.reply_message(event['replyToken'], message)
            @user.send_message!
          end
        end

      # PostbackでWebhookが送られた場合
      when Line::Bot::Event::Postback
        @user = User.find_by(line_id: event['source']['userId'])

        case  @user.letter_status
        # メッセージ確認のアクションが選択されたときの処理（手紙のデータ登録）とメッセージが届けられる日程を選択
        when 'message_registration'
          if event['postback']['data'] != 'rEsTaRt'
            @letter = Letter.create(user_id: @user.id, message: event['postback']['data'], dig: 0)
            puts @letter
            message = {
              type: 'text',
              text: "手紙を届けるのはいつにしますか？",
              quickReply: {
                items: [
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '5分後',
                      text: '5分後'
                    },
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '15分後',
                      text: '15分後'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '1時間後',
                      text: '1時間後'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '12時間後',
                      text: '12時間後'
                    }
                  },
                  {
                    type: 'action',
                    action: {
                      type: 'message',
                      label: '1日後',
                      text: '1日後'
                    }
                  },
                ]
              }
            }
            client.reply_message(event['replyToken'], message)
            @user.dig_registration!
          else  event['postback']['data'] == 'rEsTaRt'
            message = {
              type: "text",
              text: "再度、未来の自分に向けてのメッセージを送ってください"
            }
            client.reply_message(event['replyToken'], message)
            @user.before_message_registration!
          end
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