class Voucher < ApplicationRecord
  belongs_to :retailer
  has_many :voucher_targets
  
end
