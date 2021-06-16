class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
        numericality: {only_integer: true,
                       greater_than: Settings.number.greater_than}
  validates :current_price, presence: true,
        numericality: {greter_than: Settings.number.greater_than}
end
