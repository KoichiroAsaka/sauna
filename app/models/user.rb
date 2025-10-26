class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_one_attached :profile_image
end
