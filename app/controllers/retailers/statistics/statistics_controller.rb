# frozen_string_literal: true

module Retailers
  module Statistics
    class StatisticsController < ApplicationController
      before_action :authenticate_retailer!

<<<<<<< HEAD
      # /users_by_zipcode
      def users_by_gender
        @data_zip = UsersByGenderService.new(current_retailer).call!
=======
      # /retailers/statistics/users_by_zipcode
      def users_by_zipcode
        @data = UsersByZipcodeService.new(current_retailer).call!
>>>>>>> da4efda58afa002de8ea61871325e25ea50881d6

        render "retailers/statistics/users_by_gender"
      end

      # /sales_by_users_value
      def sales_by_users_value
        @data_value = SalesByUsersValueService.new(current_retailer).call!

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

      # /retailers/statistics/number_of_client
      def number_of_client
        service = NumberOfClientService.new(current_retailer, number_of_client_params)

        unless service.permitted_type?
          raise ActionController::BadRequest.new,
                I18n.t("errors.controllers.retailers.statistics.number_of_client.bad_request")
        end

        @data = service.call!

        render "retailers/statistics/number_of_client"
      end

      private

      def load_product
        @product = current_retailer.products.find_by(product_params)
      end

      def product_params
        params.permit(:id)
      end

      def number_of_client_params
        params.require(:type)
      end
    end
  end
end
