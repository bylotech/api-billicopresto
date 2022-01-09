class AddLongitudeLatitudeToUsersAndRetailers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :retailers, :latitude, :float
    add_column :retailers, :longitude, :float
  end
end
