# frozen_string_literal: true

module Retailers
  module Statistics
    class StatisticsController < ApplicationController
      # /users_by_zipcode
      def users_by_zipcode
        UsersByZipcodeService.new(current_retailer).call!
      end
    end
  end
end
