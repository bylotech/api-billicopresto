class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  load_and_authorize_resource

  FIELD_FILTER_WHITELIST = [
    
  ]

  def index
    @vouchers =  Controllers::FilterService.new(@vouchers,FIELD_FILTER_WHITELIST, filter_params).filter! if filter_params
  end

  def new 
    @products = current_retailer.products
    @product_sold = Product.joins(items: :receipt_lines).where(items: {retailer: current_retailer}).distinct
  end

  def create
    byebug
  end

  def show
    @voucher
  end

  private

  
  def filter_params
    params[:filters]&.compact_blank
  end

  def create_params
    params.permit(**create_params_schema)
  end

  def create_params_schema
    {
      create: [
        voucher: [:start_date, :end_date, :discount, :product], 
        target: [:number, :order, :product]
      ]
    }
  end
end
