class ReceiptsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  FIELD_FILTER_WHITELIST = {
    :date => {
      operator_available: true, 
      public_name_operators: I18n.t("receipts.filter.date.operator"), 
      public_name: I18n.t("receipts.filter.date.public_name")},
    :amount_including_taxes => {
      operator_available: true, 
      public_name_operators: I18n.t("receipts.filter.amount.operator"), 
      public_name: I18n.t("receipts.filter.amount.public_name")}, 
    "till.retailer" => {public_name: I18n.t("receipts.filter.retailer.public_name")},
    "retailer.city" => {public_name: I18n.t("receipts.filter.city.public_name")},
    :status => {public_name: I18n.t("receipts.filter.status.public_name")}
  }

  def index
    @receipts = @receipts.includes(:till) if filter_params && filter_params["till.retailer"]&.compact_blank.presence
    @receipts = @receipts.includes(till: :retailer) if filter_params && filter_params["retailer.city"]
    @receipts = Controllers::FilterService.new(@receipts,FIELD_FILTER_WHITELIST, filter_params).filter! if filter_params
    @receipts_ordered = @receipts.group_by { |t| t.created_at.beginning_of_year } 
    @receipts_ordered_month = @receipts.group_by { |t| t.created_at.beginning_of_month } 
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
