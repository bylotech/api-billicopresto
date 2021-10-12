class AddGenderIntegerToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :gender, :integer, null: false, default: 0

    User.all.each{|user| user.id.odd? ? user.update!(gender: :male) : user.update!(gender: :female)}
  end
end
