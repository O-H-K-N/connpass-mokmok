class Comment < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :record, foreign_key: "record_id"

  validates :content, presence: true
  validates :content, length: { in: 1..50 }, allow_blank: true
end
