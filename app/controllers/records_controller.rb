class RecordsController < ApplicationController
  before_action :set_record, only: %i[update]

  def index
    # 「回答済」のみ一覧表示
    @checked_records = current_user.records.checked.order(created_at: :desc)
    # 「未回答」のみ一覧表示
    @sent_records = current_user.records.sent.where(state: 'sent').order(created_at: :desc)
  end

  def new
    @record = current_user.records.new
  end

  def create
    @record = current_user.records.new(record_params)
    if @record.save
      redirect_to records_path
    else
      # 一旦
      redirect_to user_path(current_user)
    end
  end

  def update
    if params[:type] == 'yes'
      @record.update!(state: 'checked', result: 0)
    else params[:type] == 'no'
      @record.update!(state: 'checked', result: 1)
    end
    redirect_to records_path
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
