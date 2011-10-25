#This controller tells ruby to display all products from the database
class StoreController < ApplicationController
  def index
# MA added session to record how many times user has accessed the index action - page 125
    @products = Product.all
    session[:counter] ||= 0
    @count = session[:counter] += 1
# MA added to invoke the cart in the sidebar
    @cart = current_cart
  end
end
