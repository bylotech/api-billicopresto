FactoryBot.define do
  factory :retailer do

    sequence :name do |n|
      "Test Market #{n}"
    end

    sequence :email do |n|
      "#{name.gsub(" ","")}@example.com"
    end

    sequence :full_address do |n|
      "#{n} rue du test"
    end

    zip_code {"75018"}
    city {"Paris"}

    password { "randompassword" }
    password_confirmation { "randompassword" }
  end
end

