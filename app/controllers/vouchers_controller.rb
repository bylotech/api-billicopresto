class VouchersController < ApplicationController
  before_action :authenticate_retailer!
  load_and_authorize_resource
  def index
    @vouchers
  end

  def show
    @voucher
  end
end
