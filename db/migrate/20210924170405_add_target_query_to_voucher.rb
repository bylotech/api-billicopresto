class AddTargetQueryToVoucher < ActiveRecord::Migration[6.1]
  def change
    add_column :vouchers, :target_query, :string
  end
end
