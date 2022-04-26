class Letter < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :title, presence: true
  validates :title, length: { in: 2..20 }, allow_blank: true
  validates :future_message, presence: true
  validates :future_message, length: { in: 2..500 }, allow_blank: true
  validates :current_message, length: { maximum: 200 }, allow_blank: true
  validates :outlook, length: { maximum: 200 }, allow_blank: true
  validates :send_at, presence: true
  # validate :date_before_start
  # validate :date_before_finish

  # お届け日が今日を含め過去の日時の場合に発火
  def date_before_start
    return if send_at.blank?
    errors.add(:send_at, "は明日以降のものを選択してください") if send_at <= Date.today
  end

  # お届け日が本日の一年後より後の日時の場合に発火
  def date_before_finish
    return if send_at.blank?
    errors.add(:send_at, "は本日よりも１年以内のものを選択してください") if Date.today + 1.years < send_at
  end

  # 送付日がまだな手紙を収集
  scope :not_send, -> { where('send_at > ?', Date.today) }
  # 送付日の手紙を収集
  scope :now_send, -> { where('send_at = ?', Date.today) }
  # 送付日が過ぎた手紙を収集
  scope :sent, -> { where('send_at <= ?', Date.today) }
end
