# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { "John" }
    sequence :last_name do |n|
      "Doe #{n}"
    end
    password { "randompassword" }
    password_confirmation { "randompassword" }
    sequence :email do |_n|
      "#{first_name}#{last_name.gsub(' ', '')}@example.com"
    end
    full_address { "38 rue ordener" }
    zip_code { "75018" }
    city { "Paris" }
  end
end
