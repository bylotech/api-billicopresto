class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  
  load_and_authorize_resource :except => [:create]
  authorize_resource only: :create

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
  
  #WARNING : Many new and create 

  def new 
    @products = current_retailer.products
    @product_sold = Product.joins(items: :receipt_lines).where(items: {retailer: current_retailer}).distinct
  end

  def create
    create_voucher_params = create_params.dig(:create, :voucher)
    mapped_params = create_params_mapper(create_voucher_params)
    current_retailer.vouchers.create!(mapped_params)
  end

  def show
    @voucher
  end

  def new
    @products = current_retailer.products
    @product_sold = Product.joins(items: :receipt_lines).where(items: {retailer: current_retailer}).distinct
    @voucher = Voucher.new    
  end

  def create
   @voucher = Voucher.new(voucher_params)
    if @voucher.save
      redirect_to voucher_path(@voucher)
    else
      render :new
    end
  end

  private

  def voucher_params
    params.require(:voucher).permit()
  end
  
  def filter_params
    params[:filters]&.compact_blank
  end

  def create_params
    params.permit(**create_params_schema)
  end

  def create_params_schema
    {
      create: [
        voucher: [:start_date, :end_date, :discount, :product_id], 
        target: [:number, :order, :product]
      ]
    }
  end

  def create_params_mapper(create_voucher_params)
    mapped_params = map_money_field(create_voucher_params)
    mapped_params = convert_product_into_item(mapped_params)
  end

  def convert_product_into_item(params)
    item = current_retailer.items.find_by(product_id: params[:product_id])
    params[:item_id] = item.id
    params.delete(:product_id)
    params
  end

  def map_money_field(params)
    model_attributes = Voucher.new.attributes.keys

    return params unless money_params = params.select do|k,v| 
      model_attributes.include?("#{k}_cents")
    end

    money_params.each do |key, value|
      params["#{key}_cents"] = value.to_f*100.to_i
      params.delete(key)
    end

    params 
  end

end
