class RecordsController < ApplicationController
  def index
    # 「確認済み」のみ一覧表示
    @records = current_user.records.checked.order(created_at: :desc)
  end

  def sent
    # 「リマインド済み」のみ一覧表示
    @records = current_user.records.sent.order(created_at: :desc)
  end

  def show
    @record = current_user.records.find(params[:id])
  end

  def new
    @record = current_user.records.new
  end

  def create
    @record = current_user.records.new(record_params)
    @record.state = :draft
    if @record.save
      redirect_to records_path
    else
      render :new
    end
  end

  def destroy
    record = current_user.records.find(params[:id])
    record.destroy!
    redirect_to records_path
  end

  private

  def record_params
    params.require(:record).permit(
      :title,
      :content,
      :send_at
    )
  end
end
