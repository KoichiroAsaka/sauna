class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scene, null: false, foreign_key: true
      t.integer :result

      t.timestamps
    end
  end
end
