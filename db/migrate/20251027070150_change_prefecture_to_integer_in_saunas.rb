class ChangePrefectureToIntegerInSaunas < ActiveRecord::Migration[7.0]
  def up
    add_column :saunas, :prefecture_tmp, :integer

    Sauna.reset_column_information

    mapping = {
      "静岡県" => 0,
      "愛知県" => 1,
      "東京都" => 2,
      "山梨県" => 3,
      "shizuoka" => 0,
      "aichi" => 1,
      "tokyo" => 2,
      "yamanashi" => 3
    }

    Sauna.find_each do |s|
      s.update(prefecture_tmp: mapping[s.prefecture])
    end

    remove_column :saunas, :prefecture
    rename_column :saunas, :prefecture_tmp, :prefecture
  end

  def down
    change_column :saunas, :prefecture, :string
  end
end
