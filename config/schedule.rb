# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"


# 1時間ごとに新着イベントがあるかを確認し通知する
# every 1.hours do
#   rake 'connpass_summary:set_connpass_event'
# end