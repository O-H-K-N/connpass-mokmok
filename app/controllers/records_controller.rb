class RecordsController < ApplicationController
  def index
    @records = params[:category_id].present? ? Category.find(params[:category_id]).records : current_user.records.all.order(created_at: :desc)
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
    tag_list = params[:record][:name].split(nil)
    if count_tag(tag_list) == false
      render :new
    else
      if @record.save
        @record.save_tag(current_user.id, tag_list)
        redirect_to record_path(@record)
      else
        render :new
      end
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
      category_ids: []
    )
  end

  # 10文字以上のタグがないかをチェック
  def count_tag(tag_list)
    tag_list.each do |tag|
      if tag.length > 10
        return false
      end
    end
  end
end
