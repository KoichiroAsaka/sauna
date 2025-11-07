class CreateScenes < ActiveRecord::Migration[7.1]
  def change
    create_table :scenes do |t|
      t.text :description

      t.timestamps
    end
  end
end
