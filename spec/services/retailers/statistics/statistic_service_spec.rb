# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Retailers::Statistics::StatisticService, type: :model do
  subject { described_class.new(retailer) }
  let(:retailer) { create(:retailer) }
  let(:till) { create(:till, retailer: retailer) }
  let(:carrot) { create(:product) }
  let(:item_carrot) { create(:item, product: carrot, retailer: retailer) }
  let(:soap) { create(:product, name: 'soap') }
  let(:item_soap) { create(:item, product: soap, retailer: retailer) }

  let!(:first_user) { create(:user) }
  let!(:first_receipt) { create(:receipt, date: '2020-12-31', user: first_user, till: till) }
  let!(:first_receipt_line) do
    create(:receipt_line, item: item_carrot, receipt: first_receipt, quantity: 2, unit_price_cents: 1000)
  end

  let!(:second_user) { create(:user) }
  let!(:second_receipt) { create(:receipt, date: '2020-12-31', user: second_user, till: till) }
  let!(:second_receipt_line) do
    create(:receipt_line, item: item_carrot, receipt: second_receipt, quantity: 5, unit_price_cents: 1000)
  end

  let!(:third_user) { create(:user) }
  let!(:third_receipt) { create(:receipt, date: '2020-12-31', user: third_user, till: till) }
  let!(:third_receipt_line) do
    create(:receipt_line, item: item_soap, receipt: third_receipt, quantity: 6, unit_price_cents: 1000)
  end

  describe '#sales_by_product' do
    context 'with no args' do
      let(:expected_result) do
        [
          { product_id: carrot.id, quantity: 7 },
          { product_id: soap.id, quantity: 6 }
        ]
      end
      it 'return the list of the product sold by the retailer and the quantity, ordered by descending quantity' do
        expect(subject.sales_by_product).to eq(expected_result)
      end
    end
    context 'order: ASC' do
      let(:expected_result) do
        [
          { product_id: soap.id, quantity: 6 },
          { product_id: carrot.id, quantity: 7 }
        ]
      end
      it 'return the list of the product sold by the retailer and the quantity, ordered by ascending quantity' do
        expect(subject.sales_by_product(order: 'ASC')).to eq(expected_result)
      end
    end
    context 'limit' do
      let(:expected_result) do
        [
          { product_id: carrot.id, quantity: 7 }
        ]
      end
      it 'return the n first products by descending quantity' do
        expect(subject.sales_by_product(limit: 1)).to eq(expected_result)
      end
    end
  end
  describe '#consumer_by_product' do
    context 'with no args' do
      let(:expected_result) do
        [
          { quantity: 5, user_id: second_user.id },
          { quantity: 2, user_id: first_user.id }
        ]
      end
      it 'return the list of the product sold by the retailer and the quantity, ordered by descending quantity' do
        expect(subject.consumer_by_product(carrot.id)).to eq(expected_result)
      end
    end

    context 'with args' do
      context 'order' do
        let(:expected_result) do
          [
            { quantity: 2, user_id: first_user.id },
            { quantity: 5, user_id: second_user.id }
          ]
        end

        it 'return the list of the user and the quantity the bought of the product in ascending order' do
          expect(subject.consumer_by_product(carrot.id, order: 'ASC')).to eq(expected_result)
        end
      end

      context 'limit' do
        let(:expected_result) do
          [
            { quantity: 5, user_id: second_user.id }
          ]
        end

        it 'return the list of the user and the quantity the bought of the product in ascending order' do
          expect(subject.consumer_by_product(carrot.id, limit: 1)).to eq(expected_result)
        end
      end
    end
  end
end
