class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  load_and_authorize_resource

  FIELD_FILTER_WHITELIST = [
    'items.product_id'
  ]

  def index
    @vouchers = @vouchers.joins(:item) if filter_params&['items.product_id']
    @vouchers =  Controllers::FilterService.new(@vouchers,FIELD_FILTER_WHITELIST, filter_params).filter! if filter_params
  end

  def filter
    @products = Product.joins(:items).where(items: {retailer: current_retailer})
  end

  def show
    @voucher
  end

  private

  
  def filter_params
    params[:filters]&.compact_blank
  end
end
