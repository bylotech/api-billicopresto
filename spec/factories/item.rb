FactoryBot.define do
  factory :item do
    product {Product.last || FactoryBot.create(:product)}
    retailer {Retailer.last || FactoryBot.create(:retailer)}
  end
end
