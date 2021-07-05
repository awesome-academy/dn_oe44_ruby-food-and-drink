module OrdersHelper
  def change_status status
    [Order.statuses[:confirmed], Order.statuses[:denied]].include? status
  end
end
