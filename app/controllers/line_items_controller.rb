class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        # MA changed redirect_to(@line_item.cart) to redirect_to(@store_url) so changes to the cart render in the index as oppose to a cart page
        format.html { redirect_to(store_url) }
        # The followng tells the respond_to method to return in  a format of .js - this is for our AJAX cart in the sidebar - page 146
        # code { @current_item = @line_item } assigns an instance variable to the current line item so it can be passed to the template - page 148  
        format.js { @current_item = @line_item }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # MA reset the counter to zero when user adds something to the cart.
  def add_to_cart
    session[:counter] = 0
  end


  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    # Chris added the instance variable @cart to the destroy instance method so that we can use the destroy method with @cart
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :ok }
      format.js { }
    end
  end
  # 2. add to controller the drecrement method and it's functions - the decrement method is used in _line_item.html.erb
  def decrement
    @cart = current_cart
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.update_attribute(:quantity, @line_item.quantity - 1)
    else
      @line_item.destroy
    end
  end
end
