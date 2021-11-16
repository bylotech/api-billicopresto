# frozen_string_literal: true

module Vouchers
  FactoryBot.define do
    factory :voucher_target do
      user { nil }
      target { nil }
    end
  end
end
