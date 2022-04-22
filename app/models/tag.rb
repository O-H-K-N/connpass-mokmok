class Tag < ApplicationRecord
  has_many :record_tags, dependent: :destroy
  has_many :records, through: :record_tags
  validates :name, presence: true
  validates :name, length: { in: 1..10 }, uniqueness: true, allow_blank: true
end
