# frozen_string_literal: true

module Retailers
  module Statistics
    # returns the turnover generated by each product
    class DailyProductSalesService
      def initialize(retailer, product, **_args)
        @retailer = retailer
        @product = product
      end

      def call!
        @product.receipt_lines
                .where(items: {retailer: @retailer})
                .joins(:receipt)
                .select("receipts.date")
                .group("receipts.date")
                .order("receipts_date")
                .sum("amount_excluding_taxes_cents")
      end
    end
  end
end
