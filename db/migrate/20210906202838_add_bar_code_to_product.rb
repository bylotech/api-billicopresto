class AddBarCodeToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :barcode, :string, default: nil
  end
end
