class Image < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :image, content_type: {in: Settings.image.format,
                                   message: I18n.t(".format")},
    size: {less_than: Settings.image.size.megabytes,
           message: I18n.t(".size")}
end
