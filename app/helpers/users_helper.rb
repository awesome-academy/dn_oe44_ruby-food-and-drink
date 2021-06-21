module UsersHelper
  def user_image user
    if user.image.blank?
      image_tag("user_default.png", alt: :default,
        class: "avatar img-circle img-thumbnail")
    else
      image_tag(user.image, class: "avatar img-circle img-thumbnail")
    end
  end
end
