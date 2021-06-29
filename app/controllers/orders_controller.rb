class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order_from_cart, except: [:show, :edit]
  before_action :find_by_order, only: :show
  before_action :load_order, :check_expiration, only: :edit

  def show; end

  def new; end

  def edit
    if @order.waiting?
      @order.order_confirm
      flash[:success] = t "controllers.order_confirms.success"
    else
      flash[:danger] = t "controllers.order_confirms.fail"
      redirect_to root_path
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @order.save!
      OrderMailer.order_confirmation(@order, current_user).deliver_now
      flash[:success] = t "controllers.orders.save_success"
      session.delete :cart
      redirect_to order_path(@order)
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "controllers.orders.save_fail"
    render :new
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "controllers.order_confirms.not_found"
    redirect_to root_path
  end

  def check_expiration
    return unless @order.confirm_link_has_expired?

    flash[:danger] = t "controllers.order_confirms.expired"
    redirect_to root_path
  end

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
    raise StandardError, t("controllers.orders.empty") if current_cart.blank?

    @order = current_user.orders.new
    build_order
  rescue StandardError => e
    flash[:danger] = e.message
    redirect_to root_path
  end

  def build_order
    current_cart.each do |key, value|
      @product = Product.find_by id: key.to_i
      @order.order_details.new(product: @product,
                               quantity: value.to_i,
                               current_price: @product.price)
      next if @product

      raise StandardError, t("controllers.carts.product_empty")
    end
  end

  def find_by_order
    @order = current_user.orders.find_by id: params[:id]
    return if @order

    flash[:danger] = t "controllers.orders.not_found"
    redirect_to root_path
  end
end
