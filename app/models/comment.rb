class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :scene

  validates :content,presence: true,length: {maximum: 200}
end
