# frozen_string_literal: true

module HasAddress
  extend ActiveSupport::Concern

  included do
    geocoded_by :address
    after_commit :save_geocode_coordinates,
                 if: lambda {
                   saved_changes.slice(:full_address, :zip_code, :city).presence
                 }

    def address
      [full_address, zip_code, city].join(",")
    end

    private

      def save_geocode_coordinates
        coordinates = geocode
        update!(
          latitude: coordinates.first,
          longitude: coordinates.last,
        )
      end
  end
end
