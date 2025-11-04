class Post < ApplicationRecord
  belongs_to :user
  belongs_to :sauna
  has_one_attached :image

  enum congestion_level: { level1: 1, level2: 2, level3: 3, level4: 4, level5: 5 }
  enum day_of_week: {
    sunday: 0, monday: 1, tuesday: 2, wednesday: 3,
    thursday: 4, friday: 5, saturday: 6
  }
  enum time_zone: {
    morning1: 0, morning2: 1, noon: 2, afternoon1: 3,
    afternoon2: 4, evening1: 5, evening2: 6, night: 7
  }
  enum status: { draft: 0, published: 1 }

  # ✅ バリデーション
  validates :sauna_id, presence: true, unless: :draft?
  validates :congestion_level, :day_of_week, :time_zone, presence: true, unless: :draft?
  validates :post, presence: true, unless: :draft?
end
