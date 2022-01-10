# frozen_string_literal: true

module Retailers
  module Statistics
    # returns the number of client
    class NumberOfClientService
      LOCALS_DISTANCE_FROM_RETAILER = 1
      TYPE_WHITELIST = %w[
        by_age
        by_localisation
        by_gender
      ].freeze

      def initialize(retailer, type)
        @retailer = retailer
        @type = type
      end

      def call!
        sanitized_data
      end

      def permitted_type?
        TYPE_WHITELIST.include? @type
      end

      private

      def by_age
        {
          kids: customers.where(birthday: 14.years.ago...).count,
          teenagers: customers.where(birthday: 18.years.ago..15.years.ago).count,
          young_adults: customers.where(birthday: 30.years.ago..19.years.ago).count,
          adults: customers.where(birthday: 50.years.ago..31.years.ago).count,
          seniors: customers.where("birthday <= ?", 51.years.ago).count,
        }
      end

      def by_localisation
        locals = customers.near(@retailer.to_coordinates, LOCALS_DISTANCE_FROM_RETAILER, units: :km)

        {
          locals: locals.size,
          not_locals: customers.count - locals.size,
        }
      end

      def by_gender
        customers.group(:gender).count.symbolize_keys
      end

      def customers
        @customers ||= @retailer.customers
      end

      def data
        @data ||= send(@type)
      end

      def sanitized_data
        data.delete_if { |_k, v| v.zero? }
      end
    end
  end
end
