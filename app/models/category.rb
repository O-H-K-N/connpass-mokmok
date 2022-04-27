class Category < ApplicationRecord
  has_many :record_categories, dependent: :destroy
  has_many :records, through: :record_categories
  validates :name, presence: true
  validates :name, length: { in: 1..20 }, uniqueness: true, allow_blank: true
end
