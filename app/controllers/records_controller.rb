class RecordsController < ApplicationController
  def index
    # 「解答済」のみ一覧表示
    @records = current_user.records.checked.order(created_at: :desc)
  end

  def sent
    # 「未解答」のみ一覧表示
    @records = current_user.records.sent.where(state: 'sent').order(created_at: :desc)
  end

  def show
    @record = current_user.records.find(params[:id])
  end

  def new
    @record = current_user.records.new
  end

  def create
    @record = current_user.records.new(record_params)
    if @record.save
      redirect_to records_path
    else
      render :new
    end
  end

  def update
    @record = current_user.records.find(params[:id])
    if params[:type] == 'correct'
      @record.update!(state: 'checked', result: 'correct')
    else params[:type] == 'wrong'
      @record.update!(state: 'checked', result: 'wrong')
    end
    redirect_to sent_path
  end

  def ckecked
    @record = current_user.records.find(params[:id])
    @record.update(stat)
  end

  def destroy
    record = current_user.records.find(params[:id])
    record.destroy!
    redirect_to records_path
  end

  private

  def record_params
    params.require(:record).permit(
      :content,
      :send_at
    )
  end
end
