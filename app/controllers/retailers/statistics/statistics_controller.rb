# frozen_string_literal: true

module Retailers
  module Statistics
    class StatisticsController < ApplicationController
      before_action :authenticate_retailer!

      # /users_by_zipcode
      def users_by_zipcode
        @data = UsersByZipcodeService.new(current_retailer).call!

        render "retailers/statistics/users_by_zipcode"
      end

      # /sales_by_users_value
      def sales_by_users_value
        @data = SalesByUsersValueService.new(current_retailer).call!

        render "retailers/statistics/sales_by_users_value"
      end

      # /sales_by_products_value
      def sales_by_products_value
        @data = SalesByProductsValueService.new(current_retailer).call!

        render "retailers/statistics/sales_by_products_value"
      end

      # /daily_product_sales/:product_id
      def daily_product_sales
        load_product

        not_found unless @product

        @data = DailyProductSalesService.new(current_retailer, @product).call!

        render "retailers/statistics/daily_product_sales"
      end

      private

      def load_product
        @product = current_retailer.products.find_by(product_params)
      end

      def product_params
        params.permit(:id)
      end
    end
  end
end
