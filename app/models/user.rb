class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum letter_status: { send_message: 0, message_registration: 1, dig_registration: 2 }

end
