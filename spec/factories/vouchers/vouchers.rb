# frozen_string_literal: true

module Vouchers
  FactoryBot.define do
    factory :voucher, class: "Vouchers::Voucher" do
      retailer { Retailer.last || FactoryBot.create(:retailer) }
      item { retailer.items.last || FactoryBot.create(:item, retailer: retailer, product: FactoryBot.create(:product)) }
      kind { 1 }
    end
  end
end
