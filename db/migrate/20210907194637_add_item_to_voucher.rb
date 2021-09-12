class AddItemToVoucher < ActiveRecord::Migration[6.1]
  def change
    add_reference :vouchers, :item, null: false, foreign_key: true
  end
end
