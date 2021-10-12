# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :receipts, dependent: :destroy
  has_many :tills, through: :receipts
  has_many :retailers, through: :tills
  enum gender: [:undefined, :male, :female]

  def age
    Date.current.year - birthday.year
  end
end
