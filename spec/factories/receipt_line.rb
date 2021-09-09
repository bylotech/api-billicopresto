FactoryBot.define do
  factory :receipt_line do
    receipt { Receipt.last || FactoryBot.create(:receipt) }

    sequence :quantity do |n|
      n
    end

    unit_price_cents {199}

    taxe_rate {20}

    item {Item.last || FactoryBot.create(:item)}
  end
end
