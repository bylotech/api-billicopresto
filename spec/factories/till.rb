FactoryBot.define do
  factory :till do
    retailer {Retailer.last || FactoryBot.create(:retailer)}
    sequence :reference do |n|
      n
    end
  end
end