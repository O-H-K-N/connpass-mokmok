class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(id: params[:id])
    if @tag
      records = @tag.records.all
      unless params[:category_id].nil? ||params[:category_id].length == 0
        # ActiveRecordRelationを作成し直す
        records = Record.where(id: records.map { |record| filter_record(record, params[:category_id]) })
        @records = records.all.order(created_at: :desc)
      else
        @records = records.all.order(created_at: :desc)
      end
    else
      redirect_to records_path
    end
  end

  private

  # タグで絞り込まれた記録の中に、指定したカテゴリーが含まれているかを検証
  def filter_record(record, params)
    record if record.categories.find_by(id: params).present?
  end
end
