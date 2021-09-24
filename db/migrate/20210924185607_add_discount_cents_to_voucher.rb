class AddDiscountCentsToVoucher < ActiveRecord::Migration[6.1]
  def change
    add_column :vouchers, :discount_cents, :integer, default: 0
  end
end
