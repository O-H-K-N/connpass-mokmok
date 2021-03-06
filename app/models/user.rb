class User < ApplicationRecord
  has_one :connpass, dependent: :destroy
  validates :line_id, presence: true, uniqueness: true
  validates :account, presence: true, on: :update
  validates :prefecture, presence: true, on: :update
  validates :word_first, presence: true, on: :update
  validates :word_first, length: { in: 2..10 }, allow_blank: true
  validates :word_second, length: { in: 2..10 }, allow_blank: true, on: :update
  validates :word_third, length: { in: 2..10 }, allow_blank: true, on: :update
  validates :count, presence: true, on: :update
  validates :checked, inclusion: [true, false]

  enum prefecture:{
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,
    沖縄県:47
  }

  # 通知ONのUserを収集
  scope :checked_user, -> { where(checked: true) }

  # ラインクライアントに接続するメソッド
  def self.line_client
    Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # connpassのオンラインイベント取得メソッド
  def self.get_online_events(url)
    # インスタンスを生成
    uri = URI.parse(url)
    # リクエストを送りjson形式で受け取る
    json =  Net::HTTP.get(uri)
    # ハッシュ形式に返還
    data = JSON.parse(json)

    # 開催前のイベントを抽出
    events = data["events"].map do |event|
      if event["started_at"] > DateTime.now && event["address"].try(:exclude?, "都") && event["address"].try(:exclude?, "道") && event["address"].try(:exclude?, "府") && event["address"].try(:exclude?, "県")
        event
      else
        next
      end
    end

    return events
  end

  # connpassのイベント取得メソッド
  def self.get_events(url)
    # インスタンスを生成
    uri = URI.parse(url)
    # リクエストを送りjson形式で受け取る
    json =  Net::HTTP.get(uri)
    # ハッシュ形式に返還
    data = JSON.parse(json)

    # 開催前のイベントを抽出
    events = data["events"].map do |event|
      if event["started_at"] > DateTime.now
        event
      else
        next
      end
    end

    return events
  end

  # 取得したイベントをFLEX_MESSAGEでセット
  def self.set_events(event)
    {
      "type": "flex",
      "altText": event['title'],
      "contents": {
        "type": "bubble",
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": event['title'],
              "weight": "bold",
              "size": "lg",
              "wrap": true,
            },
            {
              "type": "box",
              "layout": "vertical",
              "margin": "lg",
              "spacing": "sm",
              "contents": [
                {
                  "type": "box",
                  "layout": "baseline",
                  "spacing": "sm",
                  "contents": [
                    {
                      "type": "text",
                      "text": "会場",
                      "color": "#aaaaaa",
                      "size": "sm",
                      "flex": 2
                    },
                    {
                      "type": "text",
                      "text": event['place'],
                      "wrap": true,
                      "color": "#666666",
                      "size": "sm",
                      "flex": 5
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "baseline",
                  "spacing": "sm",
                  "contents": [
                    {
                      "type": "text",
                      "text": "開始日時",
                      "color": "#aaaaaa",
                      "size": "sm",
                      "flex": 2
                    },
                    {
                      "type": "text",
                      "text": event["started_at"].to_datetime.strftime("%Y/%m/%d %-H:%M〜"),
                      "wrap": true,
                      "color": "#666666",
                      "size": "sm",
                      "flex": 5
                    }
                  ]
                }
              ]
            }
          ]
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "uri",
                "label": "イベント詳細へ",
                "uri":  event["event_url"]
              }
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [],
              "margin": "sm"
            }
          ],
          "flex": 0
        }
      }
    }
  end

  # イベントの取得順設定をFLEX_MESSAGEでセット
  def self.set_order(word)
    {
      "type": "flex",
      "altText": "イベントの取得順を選択",
      "contents": {
        "type": "bubble",
        "body": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "text",
              "wrap": true,
              "weight": "bold",
              "size": "xl",
              "text": "イベントの取得順を選択"
            },
            {
              "type": "text",
              "text": "イベントは最高で5件取得されます。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "開催が近い順 or ランダムのいずれかを選択してください。",
              "color": "#aaaaaa",
              "wrap": true,
              "size": "sm",
            },
          ]
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "開催が近い順",
                "data": "new_#{word}"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "ランダム",
                "data": "randam_#{word}"
              }
            }
          ]
        }
      }
    }
  end
end
