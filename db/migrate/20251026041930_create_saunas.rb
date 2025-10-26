class CreateSaunas < ActiveRecord::Migration[7.1]
  def change
    create_table :saunas do |t|
      t.string :name
      t.integer :prefecture
      t.string :address

      t.timestamps
    end
  end
end
