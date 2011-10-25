# MA - This script will create 100 orders with no line items in them - page 177
Order.transaction do
  (1..100).each do |i|
    Order.create(:name => "Customer #{i}", :address => "#{i} Main Street", :email => "customer-#{i}@example.com", :pay_type => "Check")
  end
end 