module ProductsHelper
  def product_image product
    if product.images.blank?
      image_tag("image_default.jpg")
    else
      image_tag(product.images.first, class: "food")
    end
  end
end
