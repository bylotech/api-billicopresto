# frozen_string_literal: true

module Retailers
  module Statistics
    # returns the number of users by zipcode
    class UsersByGenderService
      def initialize(retailer)
        @retailer = retailer
      end

      def call!
        User.joins(receipts: :till)
            .where(tills: {retailer: @retailer})
            .distinct
            .group(:gender)
            .order(:count_id)
            .count
      end
    end
  end
end
