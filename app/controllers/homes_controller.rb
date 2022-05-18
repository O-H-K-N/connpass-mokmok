class HomesController < ApplicationController
  skip_before_action :login_required, only: %i[set top use privasy terms contact]
  before_action :set_liff_keyword_id, only: %i[set]

  def set; end

  def top; end

  def use; end

  def privasy; end

  def terms; end

  def contact; end

  def events
    # ユーザが登録したキーワードに関するもくもく会を取得
    url = URI.encode"https://connpass.com/api/v1/event/?keyword=もくもく会&keyword_or=#{current_user.word_first}&keyword_or=#{current_user.word_second}&keyword_or=#{current_user.word_third}&count=100&order=2"
		events = User.get_events(url)
    @events = events.reverse.compact
  end
end
