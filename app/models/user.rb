class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :comments, dependent: :destroy
end
