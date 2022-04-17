class Letter < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  # 届け日となった手紙を収集
  scope :dig_noticed, -> { where(dig_notice: Date.today) }

end
