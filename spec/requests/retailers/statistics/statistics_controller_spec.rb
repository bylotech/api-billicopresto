# frozen_string_literal: true

require "rails_helper"
require "./spec/support/shared_examples/retailer_authenticated_page_example"

RSpec.describe "Retailers::Statistics::StatisticsController", type: :request do
  describe "GET /users_by_zipcode" do
    it_behaves_like "retailer authenticated page", "/retailers/statistics/users_by_zipcode"
  end
end
