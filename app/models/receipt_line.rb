class ReceiptLine < ApplicationRecord
  belongs_to :item
  belongs_to :receipt
end
