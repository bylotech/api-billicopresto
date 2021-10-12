# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Retailers::Retailers", type: :request do
  describe "GET /statistics" do
    it "returns http success" do
      get "/retailers/retailer/statistics"
      expect(response).to have_http_status(:success)
    end
  end
end
