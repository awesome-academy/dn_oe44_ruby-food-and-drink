class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
        numericality: {only_integer: true,
                       greater_than: Settings.number.greater_than}
  validates :current_price, presence: true,
        numericality: {greter_than: Settings.number.greater_than}

  validate :product_present
  validate :order_present

  delegate :name, :quantity, to: :product, prefix: true

  before_save :finalize

  def total
    quantity * current_price
  end

  private

  def product_present
    return if product

    errors.add(:product, :product_nil)
  end

  def order_present
    return if order

    errors.add(:order, :order_nil)
  end

  def finalize
    self[:current_price] = current_price
  end
end
