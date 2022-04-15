class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum letter_status: { send_message: 0, before_message_registration: 1, message_registration: 2, dig_registration: 3 }

end
