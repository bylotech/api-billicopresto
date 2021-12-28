class ReceiptsController < ApplicationController
  before_action :authenticate! 
  load_and_authorize_resource
  FIELD_FILTER_WHITELIST = [
    :date, 
    :amount_including_taxes, 
    "till.retailer",
    "retailer.city",
    :status
  ]

  def index

    if current_user == current_retailer
      @receipts = @receipts.includes(:till) if filter_params && filter_params["till.retailer"].presence 

      # old master : @receipts = @receipts.includes(:till) if filter_params && filter_params["till.retailer"]&.compact_blank.presence

      @receipts = @receipts.includes(till: :retailer) if filter_params && filter_params["retailer.city"]
      @receipts = Controllers::FilterService.new(@receipts,FIELD_FILTER_WHITELIST, filter_params).filter! if filter_params
      @receipts_ordered = @receipts.group_by { |t| t.created_at.beginning_of_year } 
      @receipts_ordered_month = @receipts.group_by { |t| t.created_at.beginning_of_month } 
    else
      # @receipts = Receipt.where(retailer: current_retailer)
      @receipts = current_retailer.receipts
    end

  end

  def filter
    retailers_id = @receipts.includes(till: :retailer).pluck('tills.retailer_id').uniq
    @retailers = Retailer.where(id: retailers_id)
  end

  def show
    @receipt
    @retailer = @receipt.till.retailer
    @lines = @receipt.receipt_lines
  end

  private

  def filter_params
    params[:filters]&.compact_blank
  end
end
