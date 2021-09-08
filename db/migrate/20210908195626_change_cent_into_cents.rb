class ChangeCentIntoCents < ActiveRecord::Migration[6.1]
  def change
    rename_column :receipt_lines, :unit_price_cent, :unit_price_cents
    rename_column :receipt_lines, :amount_taxe_cent, :amount_taxe_cents
    rename_column :receipt_lines, :amount_excluding_taxes_cent, :amount_excluding_taxes_cents
    rename_column :receipt_lines, :amount_including_taxes_cent, :amount_including_taxes_cents
    rename_column :receipts, :amount_excluding_taxes_cent, :amount_excluding_taxes_cents
    rename_column :receipts, :amount_including_taxes_cent, :amount_including_taxes_cents
    rename_column :receipts, :amount_taxes_cent, :amount_taxes_cents
  end
end
