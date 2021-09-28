class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  
  load_and_authorize_resource :except => [:create]
  authorize_resource only: :create

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
    mapped_params = map_money_field(create_params.dig(:create, :voucher))
    byebug
    Voucher.create!(mapped_params)
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

  def map_money_field(params)
    model_attributes = Voucher.new.attributes.keys

    return params unless money_params = params.select do|k,v| 
      model_attributes.include?("#{k}_cents")
    end

    money_params.each do |key, value|
      params["#{key}_cents"] = value.to_f*100
      params.delete(key)
    end

    params 
  end

end
