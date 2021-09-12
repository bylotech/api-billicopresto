class CreateVouchers < ActiveRecord::Migration[6.1]
  def change
    create_table :vouchers do |t|
      t.references :retailer, null: false, foreign_key: true
      t.integer :kind

      t.timestamps
    end
  end
end
