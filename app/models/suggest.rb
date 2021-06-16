class Suggest < ApplicationRecord
  belongs_to :user

  enum status: {waiting: 0, accepted: 1, deny: 2}

  validates :name, presence: true
  validates :infor, presence: true
end
