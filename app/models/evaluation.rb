class Evaluation < ApplicationRecord
  belongs_to :user
  belongs_to :scene

  validates :result, presence: true
end
