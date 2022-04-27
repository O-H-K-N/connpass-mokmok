class Record < ApplicationRecord
  has_many :record_categories, dependent: :destroy
  has_many :categories, through: :record_categories
  has_many :record_tags, dependent: :destroy
  has_many :tags, through: :record_tags
  has_many :comments, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  validates :category_ids, presence: true
  validates :theme, presence: true
  validates :theme, length: { in: 2..100 }, allow_blank: true
  validates :content, presence: true
  validates :content, length: { in: 2..400 }, allow_blank: true

  # タグを保存するメソッド
  def save_tag(user_id, tag_list)
    # 送られてきたタグリストの重複チェック
    sent_tags = tag_list.uniq
    # タグを作成するユーザを抽出
    user = User.find(user_id)

    # 全てのタグの名前を配列として取得する
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 既に存在しているタグから、送信されてきたタグを除いたものをold_tagsとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから、既に存在しているタグを除いたものをnew_tagsとする
    new_tags = sent_tags - current_tags

    # 古いタグを削除する
    old_tags.each do |old|
      self.tags.delete user.tags.find_by(name: old)
    end

    # 新たなタグをデータベースに保存する
    new_tags.each do |new|
      new_tag = user.tags.find_or_create_by(name: new)
      self.tags << new_tag
    end
  end
end
