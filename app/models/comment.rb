class Comment < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :record, foreign_key: "record_id"
end
