# frozen_string_literal: true

class Daily::Vouchers::TurnVouchersStatusToTerminatedJob < ApplicationJob
  queue_as :default

  def perform
    Vouchers::Voucher.where(end_date: Date.yesterday).update(status: :terminated)
  end
end
