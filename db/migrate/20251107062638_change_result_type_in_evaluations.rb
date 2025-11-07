class ChangeResultTypeInEvaluations < ActiveRecord::Migration[7.1]
  def change
    change_column :evaluations, :result, :string
  end
end
