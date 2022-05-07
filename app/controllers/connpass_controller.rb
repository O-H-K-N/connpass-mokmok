class ConnpassController < ApplicationController
  before_action :set_user, only: %i[new update]

  def new
    @connpass = @user.connpass
  end

  def update
    @connpass = Connpass.find(params[:id])
    if @connpass.update(connpass_params)
      redirect_to user_path(@user)
    end
  end

  private

  def connpass_params
    params.require(:connpass).permit(:account)
  end

  def set_user
    @user = current_user
  end
end
