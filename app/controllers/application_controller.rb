class ApplicationController < ActionController::Base

  private

  def set_liff_top_id
    gon.liff_id = ENV['LIFF_TOP_ID']
  end

  def set_liff_record_id
    gon.liff_id = ENV['LIFF_RECORD_ID']
  end
end
