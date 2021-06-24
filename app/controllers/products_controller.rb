class ProductsController < ApplicationController
  before_action :load_product, only: :show

  def show; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "controllers.carts.product_empty"
    redirect_to root_path
  end
end
