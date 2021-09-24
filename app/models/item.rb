class Item < ApplicationRecord
  belongs_to :retailer
  belongs_to :product
  has_many :receipt_lines
end
