module Vouchers
  class Voucher < ApplicationRecord
    belongs_to :retailer
    has_many :voucher_targets
    belongs_to :item
    has_one :product, through: :item
  
    enum status: [ :active, :terminated , :canceled ]
    
  end
end
