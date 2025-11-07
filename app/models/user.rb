class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorites_saunas, through: :favorites, source: :sauna
  has_many :followers_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :followings_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy

  has_many :followers, through: :followers_relationships, source: :follower
  has_many :followings, through: :followings_relationships, source: :followed
  
  # ユーザーをフォローする
def follow(user_id)
  followings_relationships.create(followed_id: user_id)
end

# ユーザーのフォローを外す
def unfollow(user_id)
  followings_relationships.find_by(followed_id: user_id)&.destroy
end

# すでにフォローしていれば true を返す
def following?(user)
  followings.include?(user)
end

  has_many :evaluations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_image
  validates :name, presence: true
end
