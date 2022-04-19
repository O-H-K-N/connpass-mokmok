class Record < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  validates :category, presence: true
  validates :title, presence: true
  validates :title, length: { in: 2..20 }, allow_blank: true
  validates :content, presence: true
  validates :content, length: { in: 5..400 }, allow_blank: true
  enum category: { episode: 0, success_story: 1, failure_story: 2 }
end
