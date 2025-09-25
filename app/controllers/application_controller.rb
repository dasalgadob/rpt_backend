class ApplicationController < ActionController::API
  respond_to :json
  
  # Handle JWT specific errors
  rescue_from JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError do |exception|
    render json: {
      status: 401,
      error: 'Unauthorized',
      message: 'Invalid or expired token.'
    }, status: :unauthorized
  end
  
  # Handle Warden JWT auth errors
  rescue_from Warden::JWTAuth::Errors::RevokedToken do |exception| 
    render json: {
      status: 401,
      error: 'Unauthorized',
      message: 'Token has been revoked.'
    }, status: :unauthorized
  end
  
  # Handle authentication failures before they can redirect
  before_action :ensure_json_request
  before_action :authenticate_user!, unless: :skip_authentication?
  
  protected
  
  # Helper method to get current user's company context if needed
  def current_user_company
    current_user&.company
  end
  
  private
  
  # Define which endpoints should skip authentication
  def skip_authentication?
    # Skip authentication for Devise controllers
    controller_path.start_with?('users/') ||
    # Skip authentication for health checks and any other public endpoints
    controller_name == 'rails/health' ||
    (controller_name == 'application' && action_name == 'health') ||
    public_endpoint?
  end
  
  # Override this method in child controllers to define public endpoints
  def public_endpoint?
    false
  end
  
  # Ensure JSON responses for API
  def ensure_json_request
    request.format = :json
  end
  
  # Override Devise's failure handling to return JSON
  def authenticate_user!
    return if skip_authentication?
    
    # If no Authorization header is present
    unless request.headers['Authorization'].present?
      render json: {
        status: 401,
        error: 'Unauthorized',
        message: 'Authentication token required.'
      }, status: :unauthorized
      return
    end
    
    # Let Devise handle JWT authentication
    begin
      super
    rescue => e
      # If authentication fails for any reason, return 401
      render json: {
        status: 401,
        error: 'Unauthorized',
        message: 'Invalid or expired token.'
      }, status: :unauthorized
      return
    end
    
    # Double check if user is authenticated
    unless user_signed_in?
      render json: {
        status: 401,
        error: 'Unauthorized',
        message: 'Authentication failed.'
      }, status: :unauthorized
    end
  end
end
