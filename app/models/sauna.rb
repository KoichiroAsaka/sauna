class Sauna < ApplicationRecord
    has_many :posts, dependent: :destroy
  
    enum prefecture: {
      静岡県: 0,
      愛知県: 1,
      東京都: 2
    }
  
    validates :name, presence: true
    validates :address, presence: true
    validates :name, uniqueness: { scope: :address, message: "は同じ住所にすでに登録されています" }
  end
  