class Record < ApplicationRecord
  has_many :record_tags, dependent: :destroy
  has_many :tags, through: :record_tags
  has_many :comments, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  validates :tag_ids, presence: true
  validates :theme, presence: true
  validates :theme, length: { in: 2..40 }, allow_blank: true
  validates :content, presence: true
  validates :content, length: { in: 2..400 }, allow_blank: true
end
