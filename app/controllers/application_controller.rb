class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # Require authentication for all controllers by default
  before_action :authenticate_user!, unless: :skip_authentication?
  
  protected
  
  # Helper method to get current user's company context if needed
  def current_user_company
    # You can customize this based on your business logic
    # For now, just return the first company or implement user-company association
    current_user&.companies&.first
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
