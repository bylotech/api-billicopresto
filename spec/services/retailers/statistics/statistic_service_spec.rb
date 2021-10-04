require 'rails_helper'

RSpec.describe Retailers::Statistics::StatisticService, type: :model do

  let(:retailer) {create(:retailer)}
  let(:till) {create(:till, retailer: retailer)}
  let(:carrot) {create(:product)}
  let(:item_carrot) {create(:item, product: carrot, retailer: retailer)}
  let(:soap) {create(:product, name: 'soap')}
  let(:item_soap) {create(:item, product: soap, retailer: retailer)}
  
  let!(:first_user) {create(:user)}
  let!(:first_receipt) {create(:receipt, date: "2020-12-31", user: first_user, till: till)}
  let!(:first_receipt_line) {create(:receipt_line, item: item_carrot, receipt: first_receipt, quantity: 2, unit_price_cents: 1000)}

  let!(:second_user) {create(:user)}
  let!(:second_receipt) {create(:receipt, date: "2020-12-31", user: second_user, till: till)}
  let!(:second_receipt_line) {create(:receipt_line, item: item_carrot, receipt: second_receipt, quantity: 5, unit_price_cents: 1000)}

  let!(:third_user) {create(:user)}
  let!(:third_receipt) {create(:receipt, date: "2020-12-31", user: third_user, till: till)}
  let!(:third_receipt_line) {create(:receipt_line, item: item_soap, receipt: third_receipt, quantity: 6, unit_price_cents: 1000)}

  describe '#sales_by_product' do
    context 'with no args' do
        let(:expected_result) {[
            {:product_id=>carrot.id, :quantity=>7}, 
            {:product_id=>soap.id, :quantity=>6}
            ]}
        it 'return the list of the product sold by the retailer and the quantity, ordered by descending quantity' do
            expect(described_class.new(retailer).sales_by_product).to eq(expected_result) 
        end
    end
    context 'order: ASC' do
        let(:expected_result) {[
            {:product_id=>soap.id, :quantity=>6},
            {:product_id=>carrot.id, :quantity=>7}
            ]}
        it 'return the list of the product sold by the retailer and the quantity, ordered by ascending quantity' do
            expect(described_class.new(retailer).sales_by_product(order: 'ASC')).to eq(expected_result) 
        end
    end
    context 'limit' do
        let(:expected_result) {[
            {:product_id=>carrot.id, :quantity=>7}
            ]}
        it 'return the n first products by descending quantity' do
            expect(described_class.new(retailer).sales_by_product(limit: 1)).to eq(expected_result) 
        end
    end
  end
end
