# frozen_string_literal: true

require "rails_helper"
require "./spec/support/shared_examples/retailer_authenticated_page_example"

RSpec.describe "Retailers::Statistics::StatisticsController", type: :request do
  describe "GET /users_by_zipcode" do
    it_behaves_like "retailer authenticated page", "/retailers/statistics/users_by_zipcode"
    context "calls the correct service" do
      let(:retailer) { create(:retailer) }
      before { sign_in retailer }
      it "and returns the correct template" do
        service_double = instance_double(Retailers::Statistics::UsersByZipcodeService)
        allow(Retailers::Statistics::UsersByZipcodeService).to(
          receive(:new)
          .with(retailer)
          .and_return(service_double),
        )
        expect(service_double).to receive(:call!)
        get "/retailers/statistics/users_by_zipcode"
        expect(response).to render_template("retailers/statistics/users_by_zipcode")
      end
    end
  end

  describe "GET /retailers/statistics/number_of_client" do
    it_behaves_like "retailer authenticated page", "/retailers/statistics/number_of_client"
    let(:retailer) { create(:retailer) }
    before { sign_in retailer }
    context "when the parameter type is missing" do
      it "returns an error" do
        expect { get "/retailers/statistics/number_of_client" }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context "when the parameter is not permitted" do
      it "returns an error" do
        expect { get "/retailers/statistics/number_of_client?type=by_country" }.to raise_error(ActionController::BadRequest)
      end
    end

    context "when the parameter is permitted" do
      it "calls the correct service and renders the correct template" do
        service_double = instance_double(Retailers::Statistics::NumberOfClientService, permitted_type?: true)
        allow(Retailers::Statistics::NumberOfClientService).to(
          receive(:new)
          .with(retailer, "by_age")
          .and_return(service_double),
        )
        expect(service_double).to receive(:call!)
        get "/retailers/statistics/number_of_client?type=by_age"
        expect(response).to render_template("retailers/statistics/number_of_client")
      end
    end
  end
end
