class ReceiptLine < ApplicationRecord
  belongs_to :item
  belongs_to :receipt

  after_commit :update_amounts!, 
                if: Proc.new { saved_change_to_quantity? || saved_change_to_quantity? ||  saved_change_to_taxe_rate? }

  monetize :unit_price_cents, :amount_taxe_cents, :amount_excluding_taxes_cents, :amount_including_taxes_cents

  enum budget_category: [:leisure, :communication, :food_and_beverage, :transport, :health, :house_cleaning]


  def update_amounts!
    amount_excluding_taxes_cents = quantity*unit_price_cents
    amount_taxe_cents = amount_excluding_taxes_cents*taxe_rate/100
    amount_including_taxes_cents = amount_excluding_taxes_cents + amount_taxe_cents
    update!(
      amount_excluding_taxes_cents: amount_excluding_taxes_cents, 
      amount_taxe_cents: amount_taxe_cents, 
      amount_including_taxes_cents: amount_including_taxes_cents )
    update_receipt_amounts!
  end

  def update_receipt_amounts!
    receipt.recompute_amounts!
  end
end
