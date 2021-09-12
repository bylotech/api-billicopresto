class CreateVoucherTargets < ActiveRecord::Migration[6.1]
  def change
    create_table :voucher_targets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :voucher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
