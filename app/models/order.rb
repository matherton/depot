class Order < ActiveRecord::Base
  # MA define the options drop down for the payment form here
  PAYMENT_TYPES = [ "check", "credit card", "purchase order"]
  # MA validates entries in form here
  validates :name, :address, :email, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
  
  # MA defining the relationship between from the order to the line_item
  has_many :line_items, :dependent => :destroy
  
  # MA defintion of add_line_item_from_cart method - page 168
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  
end
