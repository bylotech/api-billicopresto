# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daily::Vouchers::TurnVouchersStatusToTerminatedJob, type: :job do
  context "perform" do
    let!(:first_voucher) { create(:voucher, end_date: Date.tomorrow) }
    let!(:first_voucher) { create(:voucher, end_date: Date.yesterday) }
    it "turns the vouchers status to terminated after there end_date" do
      expect { described_class.perform_now }.to change { Vouchers::Voucher.terminated.count }.by(1)
    end
  end
end
