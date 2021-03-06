class CartsController < ApplicationController
  before_action :load_product, :check_quantity, :check_cart,
                only: [:create, :update]
  before_action :load_order_details_from_cart, only: :show

  def show; end

  def update
    cart = current_cart
    cart[params[:product_id]] = params[:quantity].to_i
    flash[:success] = t "controllers.carts.update_success"
    session[:cart] = cart
    redirect_to carts_path
  end

  def create
    cart = current_cart
    session[:cart] = cart
    flash[:success] = t "controllers.carts.add_success"
    redirect_to carts_path
  end

  def destroy
    cart = current_cart
    if cart.reject!{|key| key.to_i == params[:id].to_i}
      flash[:success] = t "controllers.carts.delete_success"
    else
      flash[:danger] = t "controllers.carts.detele_fail"
    end
    session[:cart] = cart
    redirect_to carts_path
  end

  private

  def check_cart
    cart = current_cart
    if cart.include?(params[:product_id])
      cart[params[:product_id]] += params[:quantity].to_i
    else
      cart.store(params[:product_id].to_i, params[:quantity].to_i)
    end
  end

  def item_params
    params.fetch(:order_detail, {}).permit(:product_id, :quantity)
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t "controllers.carts.product_empty"
    redirect_to carts_path
  end

  def check_quantity
    return if params[:quantity].to_i <= @product.quantity &&
              params[:quantity].to_i.positive?

    flash[:danger] = t "controllers.carts.quantity_invalid"
    redirect_to carts_path
  end
end
