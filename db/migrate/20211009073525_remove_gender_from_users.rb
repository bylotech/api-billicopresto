class RemoveGenderFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :gender, :string
  end
end
