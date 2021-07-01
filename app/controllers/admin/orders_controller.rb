class Admin::OrdersController < Admin::BaseController
  before_action :load_order_to_admin, only: :update

  def index
    @orders = Order.newest.status.paginate(page: params[:page],
                                   per_page: Settings.page.paginate)
  end

  def update
    status = params[:status].to_i
    @order.send "#{Order.statuses.key status}!" if change_status status
    flash[:success] = t("admin.order.status", status: @order.status)
  rescue StandardError
    flash[:danger] = t "admin.order.update_fail"
  ensure
    redirect_to admin_orders_path
  end

  private

  def load_order_to_admin
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "controllers.orders.not_found"
    redirect_to admin_orders_path
  end
end
