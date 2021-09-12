class AddUsedToVoucherTarget < ActiveRecord::Migration[6.1]
  def change
    add_column :voucher_targets, :used, :boolean
    add_column :voucher_targets, :used_at, :datetime
  end
end
