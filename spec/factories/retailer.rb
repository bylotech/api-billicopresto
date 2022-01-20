# frozen_string_literal: true

FactoryBot.define do
  factory :retailer do
    sequence :name do |n|
      "Test Market #{n}"
    end

    sequence :email do |_n|
      "#{name.gsub(' ', '')}@example.com"
    end

    sequence :full_address do |n|
      "#{n} rue Ordener"
    end

    zip_code { "75018" }
    city { "Paris" }

    password { "randompassword" }
    password_confirmation { "randompassword" }
  end
end
