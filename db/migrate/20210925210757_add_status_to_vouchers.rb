class AddStatusToVouchers < ActiveRecord::Migration[6.1]
  def change
    add_column :vouchers, :status, :integer, default: 0
  end
end
