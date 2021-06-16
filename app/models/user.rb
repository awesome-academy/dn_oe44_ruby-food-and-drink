class User < ApplicationRecord
  has_many :images, dependent: :destroy

  has_many :rates, dependent: :destroy
end
