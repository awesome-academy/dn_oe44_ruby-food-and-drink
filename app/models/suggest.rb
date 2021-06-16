class Suggest < ApplicationRecord
  belongs_to :user

  enum status: {waiting: 0, accepted: 1, deny: 2}
end
