# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

# 毎分に出題日に該当するクイズを送る
every :minute do
  rake 'record_summary:send_record'
end

# 毎分に出題されて丸一日経ったクイズを無回答で回答済で処理する
every :minute do
  rake 'record_limit:checked_record'
end

# 毎朝9時に届け日に該当する手紙を送る
every  1.day, at: '9am' do
  rake 'letter_summary:send_letter'
end
