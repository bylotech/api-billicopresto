require 'rails_helper'

RSpec.describe "Vouchers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/vouchers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/vouchers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /filter" do
    it "returns http success" do
      get "/vouchers/filter"
      expect(response).to have_http_status(:success)
    end
  end

end
