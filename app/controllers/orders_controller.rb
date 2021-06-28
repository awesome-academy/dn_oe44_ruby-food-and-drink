class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order_from_cart, except: :show
  before_action :find_by_order, only: :show

  def show; end

  def new; end

  def create
    ActiveRecord::Base.transaction do
      @order.save!
      flash[:success] = t "controllers.orders.save_success"
      session.delete :cart
      redirect_to order_path(@order)
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "controllers.orders.save_fail"
    render :new
  end

  private

  def order_params
    params.require(:order).permit :name, :email, :phone, :address
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controllers.orders.must_login"
    redirect_to login_path
  end

  def load_order_from_cart
    cart = current_cart
    if cart.blank?
      flash[:danger] = t "controllers.orders.blank"
      redirect_to root_path
    else
      @order = current_user.orders.new
      cart.each do |key, value|
        @product = Product.find_by id: key.to_i
        next unless @product

        @order.order_details.new(product: @product,
                                 quantity: value.to_i,
                                 current_price: @product.price)
      end
    end
  end

  def find_by_order
    @order = current_user.orders.find_by id: params[:id]
    return if @order

    flash[:danger] = t "controllers.orders.not_found"
    redirect_to root_path
  end
end
