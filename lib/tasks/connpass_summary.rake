namespace :connpass_summary do
  desc '毎週月曜am9:00に、その週に開催されるオンラインもくもく会の情報を通知する'
	task send_connpass: :environment do
    today = Date.today.strftime("%Y%m%d")
    one = Date.tomorrow.strftime("%Y%m%d")
    two = (Date.tomorrow + 1).strftime("%Y%m%d")
    three = (Date.tomorrow + 2).strftime("%Y%m%d")
    four = (Date.tomorrow + 3).strftime("%Y%m%d")
    five = (Date.tomorrow + 4).strftime("%Y%m%d")
    six = (Date.tomorrow + 5).strftime("%Y%m%d")
    url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword=オンライン&count=100&order=2&ymd=#{today}&ymd=#{one}&ymd=#{two}&ymd=#{three}&ymd=#{four}&ymd=#{five}&ymd=#{six}"
		events = User.get_online_events(url)
    events = events.reverse.compact
    # ラインクライアントに接続
    client = User.line_client
    # 通知ONのユーザのLINE IDを集約
    user_ids = []
    User.checked_user.each { |user| user_ids << user.line_id }
    manual = { type: 'text', text: '今週開催されるオンラインもくもく会の情報です。' }
    response = client.multicast(user_ids, manual)
    p response
    if events.length != 0
      # イベントが存在する場合のみ発火
		  events.each do |event|
        message = User.set_events(event)
        response = client.multicast(user_ids, message)
		  	p response
		  end
      count = { type: 'text', text: "以上、#{events.length}件です。" }
      response = client.multicast(user_ids, count)
      p response
    else
      # イベントが存在しない場合に発火
      not_events = { type: 'text', text: "予定されているオンラインもくもく会はありません。" }
      response = client.multicast(user_ids, not_events)
      p response
		end
	end
end
