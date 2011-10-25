require 'test_helper'
# (&pound;|&#163;|&#xa3;) are values for pound but would not work so replaced with . instead of \£
# no errors but that's because it is not checking for a £ but instead using a . which just looks for something
# Chris fixed by using the unicode u00A3 for a pound - it needs to be escaped as u has a special meaning as start ofg unicode character
class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', :minimum => 4
    assert_select '#main .entry', 3
    assert_select 'h3', 'Programming Ruby 1.9'
    assert_select '.price', /\u00A3[,\d]+\.\d\d/
  end

end