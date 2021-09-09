require 'rails_helper'

RSpec.describe "Receipts", type: :request do

  let!(:user) {create(:user)}
  let(:retailer) {create(:retailer)}
  let(:till) {create(:till)}
  let(:receipt) {create(:receipt, date: "2020-12-31")}
  let(:carrot) {create(:product)}
  let(:item_carrot) {create(:item, product: carrot, retailer: retailer)}
  let!(:receipt_line) {create(:receipt_line, item: item_carrot, receipt: receipt)}

  before {sign_in user}


  fdescribe "GET /index" do
    it "returns http success" do
      get "/receipts/index" 
      expect(response).to have_http_status(:success)
      expect(assigns(:receipts)).to eq(user.receipts)
    end

    describe "filters" do
      context "date" do
          let!(:another_receipt) {create(:receipt, date: "2020-06-06")}
          context "with no operator" do
            context "when no receipt matches the filter date" do
              it "returns nothing" do
                get "/receipts/index", params: { filters: {date: "2021-02-14"}}
                expect(response).to have_http_status(:success)
                expect(assigns(:receipts)).to eq([])
              end
            end
    
            context "when there are receipts that matches the filter date" do
              it "returns the receipt" do
                get "/receipts/index", params: { filters: {date: "2020-06-06"}}
                expect(response).to have_http_status(:success)
                expect(assigns(:receipts)).to eq([another_receipt])
              end
            end
          end
          context "with operator" do
            context "less" do
              context "when no receipts have a date less than the filter value" do
                it "returns nothing" do
                  get "/receipts/index", params: { filters: {date_operator:"less", date: "2020-03-28"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq([])
                end
              end
              context "when there are receipts with a date less than the filter value" do
                it "returns nothing" do
                  get "/receipts/index", params: { filters: {date_operator:"less", date: "2020-07-01"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq([another_receipt])
                end
              end

            end
            context "more" do
              context "when no receipts have a date more than the filter value" do
                it "returns nothing" do
                  get "/receipts/index", params: { filters: {date_operator:"more", date: "2021-01-01"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq([])
                end
              end
              context "when there are receipts with a date more than the filter value" do
                it "returns nothing" do
                  get "/receipts/index", params: { filters: {date_operator:"more", date: "2020-10-10"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq([receipt])
                end
              end
            end
            context "not" do
              context "when no receipts have the same date than filyter" do
                it "returns nothing" do
                  get "/receipts/index", params: { filters: {date_operator:"not", date: "2021-01-01"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq(user.receipts)
                end
              end
              context "when there are receipts with the same date than the filter value" do
                it "returns the receipts with different dates" do
                  get "/receipts/index", params: { filters: {date_operator:"not", date: "2020-06-06"}}
                  expect(response).to have_http_status(:success)
                  expect(assigns(:receipts)).to eq([receipt])
                end
              end
            end
          end
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
