class Receipt < ApplicationRecord
  has_many :receipt_lines
  belongs_to :till
  belongs_to :user

  monetize :amount_excluding_taxes_cents,:amount_including_taxes_cents,:amount_taxes_cents

  enum status: {active: 0, archived: 1}

  after_commit :recompute_amounts!, 
                if: Proc.new { saved_change_to_amount_excluding_taxes_cents? || saved_change_to_amount_taxes_cents? }

  def recompute_amounts!
    sum_lines_excluding_taxes_cents = receipt_lines.sum(&:amount_excluding_taxes_cents)
    sum_lines_amount_taxes_cents = receipt_lines.sum(&:amount_taxe_cents)
    update!(
      amount_excluding_taxes_cents: sum_lines_excluding_taxes_cents, 
      amount_taxes_cents: sum_lines_amount_taxes_cents, 
      amount_including_taxes_cents: sum_lines_excluding_taxes_cents + sum_lines_amount_taxes_cents )
  end

  def available_items
    product_id_already_in_lines = receipt_lines.includes(:item).pluck("items.product_id")
    till.retailer.items.where.not(product_id: product_id_already_in_lines)
  end

end
