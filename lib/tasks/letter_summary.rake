namespace :letter_summary do
  desc '本日の日付が手紙の届け日時になった時、その日のam9:00に該当する手紙を送信する'
	task send_letter: :environment do
		@letters = Letter.sent
		@letters.each do |letter|
			user = User.find_by(id: letter.user_id)
			message = {
				type: 'text',
				text: "過去のあなたから手紙が届いたよ\n\n" + letter.message + "\n\n" + letter.created_at.strftime("%Y年%-m月%-d日")
			}
			client = Line::Bot::Client.new { |config|
				config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
				config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
			}
			response = client.push_message(user.line_id, message)
			p response
		end
	end
end
