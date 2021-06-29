module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def current_user? user
    user == current_user
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  def current_cart
    session[:cart] ||= Hash.new
  end

  def total price, quantity
    price * quantity
  end

  def load_order_details_from_cart
    cart = current_cart
    @total = 0
    @order_details = []
    cart.each do |key, value|
      @product = Product.find_by id: key.to_i
      next unless @product

      @order_details << OrderDetail.new(product: @product, quantity: value,
        current_price: @product.price)
      @total += @product.price * value
    end
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
