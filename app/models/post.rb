class Post < ApplicationRecord
  belongs_to :sauna
  belongs_to :user

  # 混雑度（★1〜★5）
  enum congestion_level: {
    one_star: 1,
    two_stars: 2,
    three_stars: 3,
    four_stars: 4,
    five_stars: 5
  }

  # 時間帯（7時〜23時を区分）
  enum time_zone: {
    morning_7_9: 1,
    morning_9_11: 2,
    noon_11_13: 3,
    afternoon_13_15: 4,
    afternoon_15_17: 5,
    evening_17_19: 6,
    evening_19_21: 7,
    night_21_23: 8
  }

  # バリデーション
  validates :congestion_level, presence: true
  validates :time_zone, presence: true
end
