class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order_from_cart, except: [:show, :edit, :update]
  before_action :find_by_order, only: [:show, :update]
  before_action :load_order, :check_expiration, only: :edit
  before_action :check_order, only: :update

  def show; end

  def new; end

  def edit
    if @order.waiting?
      ActiveRecord::Base.transaction do
        @order.order_confirmed
        flash[:success] = t "controllers.order_confirms.success"
      end
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
  rescue StandardError
    flash[:danger] = t "controllers.orders.save_fail"
    render :new
  end

  def update
    status = params[:status].to_i
    if status.eql?(Order.statuses[:waiting])
      ActiveRecord::Base.transaction do
        @order.cancel!
        flash[:success] = t "controllers.carts.cancel_success"
      end
    else
      flash[:danger] = t "controllers.carts.status_error"
    end
    redirect_to current_user
  rescue StandardError
    flash[:danger] = t "controllers.carts.cancel_fail"
    redirect_to current_user
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

  def check_order
    return if @order.waiting? || @order.ordered?

    flash[:danger] = t "controllers.carts.status_error"
    redirect_to current_user
  end
end
