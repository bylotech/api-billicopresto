# frozen_string_literal: true

module Retailers
  module Statistics
    class StatisticsController < ApplicationController
      # /users_by_zipcode
      def users_by_zipcode
        UsersByZipcodeService.new(current_retailer).call!
      end

      # /sales_by_users_value
      def sales_by_users_value
        SalesByUsersValueService.new(current_retailer).call!
      end

      # /sales_by_products_value
      def sales_by_products_value
        SalesByProductValueService.new(current_retailer).call!
      end
    end
  end
end
