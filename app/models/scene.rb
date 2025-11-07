class Scene < ApplicationRecord
    has_many :evaluations, dependent: :destroy
    has_many :comments, dependent: :destroy
end
