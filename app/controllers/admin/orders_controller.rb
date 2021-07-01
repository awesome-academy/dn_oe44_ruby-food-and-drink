# class Admin::OrdersController < Admin::BaseController
#   def index
#     @order = Order.newest.paginate(page: params[:page],
#                                    per_page: Settings.page.paginate)
#   end

#   private

#   def load_order_to_admin
#     @order = Order.find_by id: params[:id]
#     return if @order

#     flash[:danger] = t "controllers.orders.not_found"
#     redirect_to admin_orders_path
#   end
# end
