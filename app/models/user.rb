class User < ApplicationRecord
  validates :line_id, presence: true, uniqueness: true
  validates :account, presence: true, on: :update
  validates :count, presence: true, on: :update
end
