# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case user.class.name
    when "User"
      can [:read, :filter], Receipt, user: user
    when "Retailer"
      can [:read, :filter, :create], Vouchers::Voucher, retailer: user
    end
  end
end
