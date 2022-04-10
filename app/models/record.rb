class Record < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"
end
