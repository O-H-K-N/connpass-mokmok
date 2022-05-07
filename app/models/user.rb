class User < ApplicationRecord
  belongs_to :connpass
  validates :line_id, presence: true, uniqueness: true
end
