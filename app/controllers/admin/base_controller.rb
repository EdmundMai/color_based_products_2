class Admin::BaseController < ApplicationController
  before_filter :authenticate_admin_user!
  
  layout 'admin'
  
  def authenticate_admin_user!
    unless current_user && current_user.has_role?(:admin)
      redirect_to root_path, notice: "You do not have access to this page."
    end
  end
  
  
end