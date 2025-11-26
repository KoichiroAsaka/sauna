class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sauna, null: false, foreign_key: true
      t.text :post
      t.integer :status
      t.integer :congestion_level
      t.integer :day_of_week
      t.string :time_zone

      t.timestamps
    end
  end
end
