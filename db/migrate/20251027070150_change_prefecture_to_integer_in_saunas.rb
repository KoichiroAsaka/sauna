class ChangePrefectureToIntegerInSaunas < ActiveRecord::Migration[7.0]
  def change
    change_column :saunas, :prefecture, :integer, using: 'prefecture::integer'
  end
end
