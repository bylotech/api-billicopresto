require 'rails_helper'

RSpec.describe "Vouchers::Vouchers", type: :request do

  let(:retailer) {create(:retailer)}
  let(:till) {create(:till)}
  let(:carrot) {create(:product)}
  let(:item_carrot) {create(:item, product: carrot, retailer: retailer)}
  
  let!(:first_user) {create(:user)}
  let!(:first_receipt) {create(:receipt, date: "2020-12-31", user: first_user)}
  let!(:first_receipt_line) {create(:receipt_line, item: item_carrot, receipt: first_receipt, quantity: 2, unit_price_cents: 1000)}

  let!(:second_user) {create(:user)}
  let!(:second_receipt) {create(:receipt, date: "2020-12-31", user: second_user)}
  let!(:second_receipt_line) {create(:receipt_line, item: item_carrot, receipt: second_receipt, quantity: 2, unit_price_cents: 1000)}

  let!(:third_user) {create(:user)}
  let!(:third_receipt) {create(:receipt, date: "2020-12-31", user: third_user)}
  let!(:third_receipt_line) {create(:receipt_line, item: item_carrot, receipt: third_receipt, quantity: 2, unit_price_cents: 1000)}

  let(:create_params) do
    {
        create: {
          voucher: {
            start_date: Date.parse('30/08/2021'), 
            end_date: Date.parse('31/12/2021'), 
            discount: 0.3, 
            product_id: carrot.id
          }, 
          target: {
            number: 2, 
            order: 'ASC', 
            product_id: carrot.id
          }
        }
    }
  end
  before {sign_in retailer}

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

  fdescribe "POST /vouchers" do
    it "returns http success" do
      post "/vouchers", params: create_params
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
