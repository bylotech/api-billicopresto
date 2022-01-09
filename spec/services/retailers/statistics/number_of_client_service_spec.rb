# frozen_string_literal: true

require "rails_helper"

RSpec.describe Retailers::Statistics::NumberOfClientService do
  subject { described_class.new(retailer, kind) }
  let(:kind) { :by_age }
  let(:retailer) { create(:retailer) }
  let(:till) { create(:till, retailer: retailer) }
  let(:carrot) { create(:product) }
  let(:item_carrot) { create(:item, product: carrot, retailer: retailer) }
  let(:soap) { create(:product, name: "soap") }
  let(:item_soap) { create(:item, product: soap, retailer: retailer) }

  let!(:first_user) {
    create(
      :user,
      birthday: first_user_birthday,
      gender: :male,
      full_address: "41 rue de vouillé",
      zip_code: "75015",
      city: "Paris",
    )
  }

  let(:first_user_birthday) { 15.years.ago }
  let!(:first_receipt) { create(:receipt, date: "2020-12-31", user: first_user, till: till) }
  let!(:first_receipt_line) do
    create(:receipt_line, item: item_carrot, receipt: first_receipt, quantity: 2, unit_price_cents: 1000)
  end

  let!(:second_user) {
    create(
      :user,
      birthday: second_user_birthday,
      full_address: "36 rue de Saint-Petersbourg",
      zip_code: "75008",
      city: "Paris",
    )
  }

  let(:second_user_birthday) { 15.years.ago }
  let!(:second_receipt) { create(:receipt, date: "2020-12-31", user: second_user, till: till) }
  let!(:second_receipt_line) do
    create(:receipt_line, item: item_carrot, receipt: second_receipt, quantity: 5, unit_price_cents: 1000)
  end

  let!(:third_user) { create(:user, birthday: third_user_birthday, gender: :male) }
  let(:third_user_birthday) { 55.years.ago }
  let!(:third_receipt) { create(:receipt, date: "2020-12-31", user: third_user, till: till) }
  let!(:third_receipt_line) do
    create(:receipt_line, item: item_soap, receipt: third_receipt, quantity: 6, unit_price_cents: 1000)
  end

  context "kind" do
    context "by_age" do
      let(:expected_return) do
        {
          teenagers: 2,
          seniors: 1,
        }
      end
      it "works" do
        expect(subject.call!).to eq expected_return
      end
    end
    context "by_gender" do
      let(:kind) { :by_gender }
      let(:expected_return) do
        {
          undefined: 1,
          male: 2,
        }
      end
      it "works" do
        expect(subject.call!).to eq expected_return
      end
    end
    context "by_localisation" do
      let(:kind) { :by_localisation }
      let(:expected_return) do
        {
          locals: 1,
          not_locals: 2,
        }
      end
      it "works" do
        expect(subject.call!).to eq expected_return
      end
    end
  end
end
