class Product < ApplicationRecord
  belongs_to :category

  has_many :image, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details, source: :order
end
