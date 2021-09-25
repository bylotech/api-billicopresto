class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  load_and_authorize_resource

  FIELD_FILTER_WHITELIST = [
    
  ]

  def index
    @vouchers =  Controllers::FilterService.new(@vouchers,FIELD_FILTER_WHITELIST, filter_params).filter! if filter_params


  end

  def show
    @voucher
  end

  private

  
  def filter_params
    params[:filters]&.compact_blank
  end
end
