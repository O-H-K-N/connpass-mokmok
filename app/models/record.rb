class Record < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :send_at, presence: true
  validates :content, presence: true
  validates :content, length: { maximum: 30 }
  # validate :datetime_before_start
  # validate :datetime_before_finish

  # クイズを「未出題」「未回答（通知済み）」「回答済」に区別
  enum state: { draft: 0, sent: 1, checked: 2 }
  # クイズ状態を「無回答」「正解」「不正解」に区別
  enum result: { "無回答": 0, YES: 1,  NO: 2 }

  # お知らせが今日を含め過去の日時の場合に発火
  def datetime_before_start
    return if send_at.blank?
    errors.add(:send_at, "は未来の日時を選択してください") if send_at <= Date.today
  end

  # 出題日が本日の一年後より後の日時の場合に発火
  def datetime_before_finish
    return if send_at.blank?
    errors.add(:send_at, "は本日よりも１年以内のものを選択してください") if Date.today + 1.years < send_at
  end

  # 出題されて丸一日経ったクイズを収集
  scope :limit_over, -> { sent.where('send_at <= ?', DateTime.now - 1.day) }
end
