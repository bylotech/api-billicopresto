class AddDatesToVoucher < ActiveRecord::Migration[6.1]
  def change
    add_column :vouchers, :start_date,:date 
    add_column :vouchers, :end_date,:date 
  end
end
