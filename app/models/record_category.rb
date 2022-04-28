class RecordCategory < ApplicationRecord
  belongs_to :record
  belongs_to :category
  validates :record_id, uniqueness: { scope: :category_id }
  validates :category_id, uniqueness: { scope: :record_id }
end
