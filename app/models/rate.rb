class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, numericality: {only_integer: true,
                                    greater_than: Settings.number.greater_than,
                                    less_than: Settings.number.less_than}
end
