class Retailer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tills
  has_many :receipts, through: :tills
  has_many :items
  has_many :products, through: :items
  has_many :vouchers

  enum brand: [:carrefour_market, :monoprix, :auchan]
  
  def bigest_consumer_by_product(product, n = nil)
    users = User.joins(receipts: [:till, receipt_lines: {item: :product}])
                            .where(tills: {retailer: self}, 'item.product_id': product.id)
                            .group(:id, :product_id)
                            .order('sum_quantity DESC')
                            .sum(:quantity).to_a
    
    users = users.last(n) if n

    bigest_consumer_by_product_mapper(users)
  end

  def sales_by_product
    products = self.products.joins(items: {receipt_lines: {receipt: :till}})
        .where(tills: {retailer: self})
        .group(:id)
        .order('sum_quantity DESC')
        .sum(:quantity).to_a

    sales_by_product_mapper(products)
  end

  private

  def sales_by_product_mapper(products)
    products.map do |product|
      keys = [:product_id, :quantity]
      values = product.flatten
      [keys, values].transpose.to_h
    end
  end

  def bigest_consumer_by_product_mapper(users)
    users.map do |user|
      keys = [:user_id, :product_id, :quantity]
      values = user.flatten
      [keys,values].transpose.to_h
    end
  end
end
