class ChangeTimeZoneToIntegerInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :time_zone, :integer, using: 'time_zone::integer'
  end
end
