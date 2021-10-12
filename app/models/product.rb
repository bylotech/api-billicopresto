# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :receipt_lines, through: :items
  has_many :receipts, through: :receipt_lines
  has_many :tills, through: :receipts
  enum kind: [
    "Health and beauty",
    "Electronic accessories",
    "Home and lifestyle",
    "Sports and travel",
    "Food and beverages",
    "Fashion accessories",
  ]
end
