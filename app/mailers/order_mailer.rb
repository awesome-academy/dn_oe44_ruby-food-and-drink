class OrderMailer < ApplicationMailer
  def order_confirmation order, user
    @order = order
    @user = user
    mail to: @user.email, subject: t("mailer.order_infor")
  end
end
