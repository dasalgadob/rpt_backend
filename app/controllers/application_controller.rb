class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include DeviseTokenAuthOverride
  
  # Require authentication for all controllers by default
  before_action :authenticate_user!, unless: :skip_authentication?
  
  protected
  
  # Helper method to get current user's company context if needed
  def current_user_company
    current_user&.company
  end
  
  private
  
  # Define which endpoints should skip authentication
  def skip_authentication?
    # Skip authentication for devise_token_auth controllers
    controller_path.start_with?('devise_token_auth/') ||
    # Skip authentication for health checks and any other public endpoints
    controller_name == 'rails/health' ||
    (controller_name == 'application' && action_name == 'health') ||
    public_endpoint?
  end
  
  # Override this method in child controllers to define public endpoints
  def public_endpoint?
    false
  end
end
