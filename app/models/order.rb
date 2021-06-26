class Order < ApplicationRecord
  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, ordered: 1, confirmed: 2, deny: 3, cancel: 4}

  after_save :update_quantity_product, :save_order_details
  before_create :set_total

  def total_price
    order_details.reduce(0) do |sum, order_detail|
      if order_detail.valid?
        sum + (order_detail.quantity * order_detail.current_price)
      else
        0
      end
    end
  end

  private

  def update_quantity_product
    order_details.map do |order_detail|
      @product = order_detail.product
      @product.update quantity: (order_detail.product_quantity
                                 - order_detail.quantity)
    end
  end

  def set_total
    self[:total] = total_price
  end

  def save_order_details
    order_details.each(&:save!)
  end
end
