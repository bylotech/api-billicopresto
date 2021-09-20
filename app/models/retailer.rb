class Retailer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tills
  has_many :items
  has_many :vouchers

  enum brand: [:carrefour_market, :monoprix, :auchan]
  

  def receipts
    Receipt.includes(:till).where(tills:{retailer: self})
  end
end
