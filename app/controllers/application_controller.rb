class ApplicationController < ActionController::Base
  # LIFF IDの環境変数をセット
  def set_liff_id
    gon.liff_id = ENV['LIFF_ID']
  end
end
