require 'rails_helper'

RSpec.describe "Receipts", type: :request do
  let!(:user) {create(:user)}
  let(:retailer) {create(:retailer)}
  let(:till) {create(:till)}
  let(:receipt) {create(:receipt)}
  let(:carrot) {create(:product)}
  let(:item_carrot) {create(:item, product: carrot, retailer: retailer)}
  let!(:receipt_line) {create(:receipt_line, item: item_carrot, receipt: receipt)}
  
  before {sign_in user}


  describe "GET /index" do
    it "returns http success" do
      get "/receipts/index" 
      expect(response).to have_http_status(:success)
      expect(assigns(:receipts)).to eq(user.receipts)
    end

    fdescribe "filters" do
      it "returns http success" do
        
      end
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/receipts/#{receipt.id}"
      expect(response).to have_http_status(:success)
    end

    context "when a user tries to access another user receipt" do
      let!(:another_user) {User.create!(email: "anotheruser@example.com", last_name:"Ecrepont", first_name: "Tom", password: "Test.123", password_confirmation: "Test.123")}
      before {sign_in another_user}
      it "throws a 404" do
        get "/receipts/#{receipt.id}"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
