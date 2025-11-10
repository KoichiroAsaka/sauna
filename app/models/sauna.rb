class Sauna < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
   # ↑ 「このサウナをお気に入り登録したユーザー」

  enum prefecture: {
    shizuoka: 0,
    aichi: 1,
    tokyo: 2,
    yamanashi: 3
  }

  validates :name, presence: true
  validates :address, presence: true
  validates :name, uniqueness: { scope: :address, message: "は同じ住所にすでに登録されています" }

  def prefecture_name
    {
      "shizuoka" => "静岡県",
      "aichi" => "愛知県",
      "tokyo" => "東京都",
      "yamanashi" => "山梨県"
    }[prefecture]
  end
end
