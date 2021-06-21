class StaticPagesController < ApplicationController
  def home
    @products = Product.order_by_name_asc.paginate(page: params[:page],
                                       per_page: Settings.page.paginate)
  end
end
