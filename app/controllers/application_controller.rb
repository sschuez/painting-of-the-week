class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  # Pundit: white-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Devise white-list approach
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
      
    if request.referrer
      redirect_to(request.referrer)
    else 
      redirect_to(root_path)
    end
  end
    
  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
