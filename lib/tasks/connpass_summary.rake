namespace :connpass_summary do
  desc 'キーワードに関するもくもく会の情報をLINEチャットで通知する'
  task set_connpass_event: :environment do
    # LINEクライアントに接続
    client = User.line_client
    # 通知ONのユーザ全てに適用
    User.checked_user.each do |user|
      # ユーザが設定しているキーワードでイベント情報を新着順で取得
      url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword_or=#{user.word_first}&keyword_or=#{user.word_second}&keyword_or=#{user.word_third}&count=100&order=3"
      events = User.get_events(url)
      events = events.compact
      # 一つ目のイベント情報を取得
      event = events[0]
      # ユーザに紐付いているイベントの有無を確認
      if  !user.connpass.nil?
        # ユーザに紐付いているイベントのIDと取得したイベントIDが同じかを確認
        unless user.connpass.event_id == event["event_id"]
          # 異なる場合にユーザに紐付いたイベントを更新し、詳細をLINEチャットで送信
          user.connpass.update(event_id: event["event_id"])
          manual = { type: 'text', text: "【お知らせ】\nキーワードに関するもくもく会の開催情報です✨" }
          response = client.multicast(user.line_id, manual)
          p response
          message = User.set_events(event)
          response = client.push_message(user.line_id, message)
          p response
        end
      else
        # 無しの場合にユーザに紐付いたイベントを作成し、詳細をLINEチャットで送信
        Connpass.create(user_id: user.id, event_id: event["event_id"])
        manual = { type: 'text', text: "【お知らせ】\nキーワードに関するもくもく会の開催情報です✨" }
        response = client.multicast(user.line_id, manual)
        p response
        message = User.set_events(event)
        response = client.push_message(user.line_id, message)
        p response
      end
    end
  end
end
