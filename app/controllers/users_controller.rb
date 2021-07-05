class UsersController < ApplicationController
  before_action :check_logged_in, :load_user, only: :show

  def show
    @orders = @user.orders.newest.paginate(page: params[:page],
                                           per_page: Settings.page.paginate)
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user.not_found"
    redirect_to root_path
  end
end
