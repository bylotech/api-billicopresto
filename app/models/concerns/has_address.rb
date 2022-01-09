# frozen_string_literal: true

module HasAddress
  extend ActiveSupport::Concern

  included do
    geocoded_by :address
    after_commit :save_geocode_coordinates,
                 if: lambda {
                   saved_changes.slice(:full_address, :zip_code, :city).presence
                 }
    validates :full_address, presence: true, allow_blank: false, length: {minimum: 2}
    validates :zip_code, presence: true, allow_blank: false, length: {minimum: 2}
    validates :city, presence: true, allow_blank: false, length: {minimum: 2}

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
