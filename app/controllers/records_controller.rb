class RecordsController < ApplicationController
  def index
    @records = params[:tag_id].present? ? Tag.find(params[:tag_id]).records : current_user.records.all.order(created_at: :desc)
  end

  def show
    @record = current_user.records.find(params[:id])
    @comment = Comment.new
    @comments = @record.comments.order(created_at: :desc)
  end

  def new
    @record = current_user.records.new
  end

  def create
    @record = current_user.records.new(record_params)
    if @record.save
      redirect_to record_path(@record)
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
      :theme,
      :content,
      tag_ids: []
    )
  end
end
