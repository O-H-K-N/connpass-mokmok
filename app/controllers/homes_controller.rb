class HomesController < ApplicationController
  skip_before_action :login_required

  def top; end

  def use; end

  def privasy; end

  def terms; end

  def contact; end
end
