class UsersController < ApplicationController
  before_action :logged_in_user, :load_user, only: [:show]

  def show; end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.login"
    redirect_to login_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user.not_found"
    redirect_to root_path
  end
end
