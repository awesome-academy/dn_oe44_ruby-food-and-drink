class Admin::BaseController < ApplicationController
  before_action :check_logged_in, :require_admin

  layout "layouts/admin"
end
