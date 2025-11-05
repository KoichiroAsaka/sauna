class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :sauna
  
  validates :user_id, uniqueness: { scope: :sauna_id }  # 同じサウナを重複登録させない
end
