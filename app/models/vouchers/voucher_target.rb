module Vouchers
  class VoucherTarget < ApplicationRecord
    belongs_to :user
    belongs_to :voucher
  
    validates :user_id, uniqueness: { scope: :voucher_id }
  end
end
