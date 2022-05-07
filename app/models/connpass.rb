class Connpass < ApplicationRecord
  has_many :users, dependent: :destroy
  # 子モデルとして関連づけたuserモデルも一緒に保存する
  accepts_nested_attributes_for :users

  validates :account, length: { maximum: 20 }, allow_nil: true
end
