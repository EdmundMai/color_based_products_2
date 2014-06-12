class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :print_session_variables if !Rails.env.production?
  
  helper_method :current_or_guest_user

  def print_session_variables
    logger.debug "USER SESSION VARIABLES ARE: #{session["warden.user.user.key"].inspect}"
    logger.debug "COOKIE[:AUTH_TOKEN] IS: #{cookies.signed[:auth_token].inspect}"
    logger.debug "COOKIE[:GUEST_USER_ID] IS: #{cookies.signed[:guest_user_id].inspect}"
  end
  
  def current_or_guest_user
    if current_user
      if cookies.signed[:guest_user_id]
        # merge_carts(from: guest_user, to: current_user)
        # merge_purchase_info(from: guest_user, to: current_user)
        
        
        # guest_user.destroy
        cookies.delete(:guest_user_id)
      end
      current_user
    else
      guest_user
    end
  end
  
  def guest_user
    cookies.signed[:guest_user_id] ||= {:value => create_guest_user.id}
    @cached_guest_user ||= User.find(cookies.signed[:guest_user_id])
  rescue ActiveRecord::RecordNotFound
    cookies.delete(:guest_user_id)
    guest_user
  end
  
  private

    
    def create_guest_user
      u = loop do
        random_email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
        user = User.new(:guest_email => random_email, :guest => true)
        break user unless User.exists?(guest: true, guest_email: random_email)
      end
      u.save(:validate => false)
      cookies.permanent.signed[:guest_user_id] = {
        :value => u.id
      }
      u
    end
  
end
