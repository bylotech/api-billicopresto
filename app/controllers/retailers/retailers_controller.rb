# frozen_string_literal: true

module Retailers
  class RetailersController < ApplicationController
    before_action :authenticate_retailer!
    load_and_authorize_resource

    STATISTICS_WHITELIST = [].freeze

    # /retailers/statistics
    def statistics
      @statistics = Retailer.group(:zip_code).count
      render "retailers/statistics"
    end

    private

    def statistic_service
      @statistic_service ||= Statistics.statistic_service.new(current_retailer)
    end

    def statistic_params
      params.permit(:statistics)
    end
  end
end
