class Product < ApplicationRecord
  belongs_to :category

  has_many_attached :images
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details, source: :order

  validates :name, presence: true
  validates :infor, presence: true
  validates :price, presence: true,
    numericality: {greater_than: Settings.number.greater_than}
  validates :quantity, presence: true,
    numericality: {only_integer: true,
                   greater_than: Settings.number.greater_than}

  delegate :name, to: :category, prefix: true

  scope :order_by_name_asc, ->{order :name}
end
