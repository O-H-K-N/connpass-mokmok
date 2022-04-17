class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum letter_status: { send_letter: 0, letter_registration: 1, dig_registration: 2 }
  enum record_status: { send_record: 0, select_category: 1, title_registration: 2, content_registration: 3 }
end
