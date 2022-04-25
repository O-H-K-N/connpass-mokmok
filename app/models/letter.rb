class Letter < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :message, presence: true
  validates :message, length: { in: 2..800 }, allow_blank: true
  validates :send_at, presence: true
  validate :date_before_start
  validate :date_before_finish

  def date_before_start
    errors.add(:send_at, "は明日以降のものを選択してください") if send_at <= Date.today
  end

  def date_before_finish
    errors.add(:send_at, "は本日よりも１年以内のものを選択してください") if Date.today + 1.years < send_at
  end

  # 送付日がまだな手紙を収集
  scope :not_send, -> { where('send_at > ?', Date.today) }
  # 送付日の手紙を収集
  scope :now_send, -> { where('send_at = ?', Date.today) }
  # 送付日が過ぎた手紙を収集
  scope :sent, -> { where('send_at < ?', Date.today) }

end
