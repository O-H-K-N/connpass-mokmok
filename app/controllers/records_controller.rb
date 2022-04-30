class RecordsController < ApplicationController
  before_action :set_record, only: %i[show update]

  def index
    # 「解答済」のみ一覧表示
    @records = current_user.records.checked.order(created_at: :desc)
  end

  def sent
    # 「未解答」のみ一覧表示
    @records = current_user.records.sent.where(state: 'sent').order(created_at: :desc)
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
    if params[:type] == 'correct'
      @record.update!(state: 'checked', result: 'correct')
    else params[:type] == 'wrong'
      @record.update!(state: 'checked', result: 'wrong')
    end
    redirect_to sent_path
  end

  def destroy
    record = current_user.records.find(params[:id])
    record.destroy!
    redirect_to records_path
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def record_params
    params.permit(
      :content,
      :send_at
    )
  end
end
