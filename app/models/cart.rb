#--- MA this was not created by rails generate I manually added the file from a copy in download folder
# A cart has many line items associated with it and :dependant => :destroy means line item is dependant on existence of a cart 
class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
# check to see if our list of items already includes the product we are adding; if it does, it bumps the quantity, and if it doesn’t, it builds a new LineItem 
# did not define find_products_by_id method but because it starts with the string find_by and ends with the name of a column it dynamically constructs a finder method - page 127 for full explanation
  
  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(:product_id => product_id)
    end
    current_item
  end
  
  def total_items 
    line_items.sum(:quantity)
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
