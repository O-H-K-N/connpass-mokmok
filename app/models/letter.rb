class Letter < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :message, presence: true
  validates :message, length: { in: 2..800 }, allow_blank: true
  validates :dig_notice, presence: true
  validate :date_before_start
  validate :date_before_finish

  def date_before_start
    errors.add(:dig_notice, "は明日以降のものを選択してください") if dig_notice <= Date.today
  end

  def date_before_finish
    errors.add(:dig_notice, "は本日よりも１年以内のものを選択してください") if Date.today + 1.years < dig_notice
  end

  # 届け日となった手紙を収集
  scope :dig_noticed, -> { where(dig_notice: Date.today) }

end
