class HomesController < ApplicationController
  skip_before_action :login_required, only: %i[start]
  before_action :set_liff_top_id, only: %i[top]

  def start;end

  def top
    @letters = current_user.letters.all
    @records = current_user.records.all
  end
end
