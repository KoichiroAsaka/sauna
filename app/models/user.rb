class User < ApplicationRecord
  # Deviseモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # 関連付け       
  has_many :posts, dependent: :destroy
   
  # お気に入り関連
  has_many :favorites, dependent: :destroy
  has_many :favorited_saunas, through: :favorites, source: :sauna

  # フォロー・フォロワー関連
  has_many :follower_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :following_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy

  has_many :followers, through: :follower_relationships, source: :follower
  has_many :followings, through: :following_relationships, source: :followed
  
  # ユーザーをフォローする
def follow(user_id)
  following_relationships.create(followed_id: user_id)
end

# ユーザーのフォローを外す
def unfollow(user_id)
  following_relationships.find_by(followed_id: user_id)&.destroy
end

# すでにフォローしていれば true を返す
def following?(user)
  followings.include?(user)
end

# その他関連（モラル画面におけるGood,bad、コメント、プロフィール画像）
  has_many :evaluations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_image
  
# バリデーション
  validates :name, presence: true
end
