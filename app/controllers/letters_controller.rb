class LettersController < ApplicationController
  def index
    # 「送付済み」のみ一覧表示
    @letters = current_user.letters.sent.order(created_at: :desc)
  end

  def show
    @letter = current_user.letters.find(params[:id])
  end

  def new
    @letter = current_user.letters.new
  end

  def create
    @letter = current_user.letters.new(letter_params)
    if @letter.save
      redirect_to letters_path
    else
      render :new
    end
  end

  def destroy
    letter = current_user.letters.find(params[:id])
    letter.destroy!
    redirect_to letters_path
  end

  private

  def letter_params
    params.require(:letter).permit(
      :send_at,
      :title,
      :current_message,
      :outlook,
      :future_message
    )
  end

  def sort_params
    params.permit(:sort)
  end
end
