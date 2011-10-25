require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  
  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.
  test "buying a product"
    LineItem.delete_all 
    Order.delete_all 
    ruby_book = products(:ruby)
    
    # Let’s attack the first sentence in the user story: A user goes to the store index page.
    get "/"
    assert_response :success
    assert_template "index"
    # Second sentence: They select a product adding it to their new cart NOTE: may cause problem as I think I am using JSON not XML
    xml_http_request :post, '/line_items', :product_id => ruby_book.id
    assert_response :success
    # Check that it is in the cart
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    # They then check out this is an easy test apparently - page 190
    get "/orders/new"
    assert_response :success
    assert_template "new"
    # Check that we have posted the form data to the save_order and been redirected to the index page and finely check that the cart is empty
    # page 191
    post_via_redirect "/orders",
                          :order => { :name     => "Dave Thomas",
                                      :address  => "123 The Street",
                                      :email    => "dave@example.com",
                                      :pay_type => "Check" }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    # Since we cleared the orders table at the start of the test we will now check that it only contains our new order - page 191
    orders = Order.all
        assert_equal 1, orders.size
        order = orders[0]

        assert_equal "Dave Thomas",      order.name
        assert_equal "123 The Street",   order.address
        assert_equal "dave@example.com", order.email
        assert_equal "Check",            order.pay_type

        assert_equal 1, order.line_items.size
        line_item = order.line_items[0]
        assert_equal ruby_book, line_item.product
    # Finally, we’ll verify that the mail itself is correctly addressed and has the expected subject line:
    mail = ActionMailer::Base.deliveries.last
        assert_equal ["dave@example.com"], mail.to
        assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
        assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
end
