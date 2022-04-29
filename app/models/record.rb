class Record < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :send_at, presence: true
  validates :title, presence: true
  validates :title, length: { in: 1..50 }, allow_blank: true
  validates :content, length: { maximum: 100 }
  validates :state, presence: true
  # validate :datetime_before_start
  # validate :datetime_before_finish

  # リマインドを「未通知」「確認待ち（通知済み）」「確認済み」に区別
  enum state: { draft: 0, sent: 1, checked: 2 }

  # お知らせが今日を含め過去の日時の場合に発火
  def datetime_before_start
    return if send_at.blank?
    errors.add(:send_at, "は未来の日時を選択してください") if send_at <= Date.today
  end

  # お知らせ日が本日の一年後より後の日時の場合に発火
  def datetime_before_finish
    return if send_at.blank?
    errors.add(:send_at, "は本日よりも１年以内のものを選択してください") if Date.today + 1.years < send_at
  end

  # お知らせ日がまだなリマインドを収集
  scope :not_send, -> { where('send_at > ?', DateTime.now) }
  # お知らせ日が過ぎたリマインドを収集
  scope :sent, -> { where('send_at <= ?', DateTime.now) }
  # 確認済みとなったリマインドを収集
  scope :checked, -> { where(state: 'checked') }
end
