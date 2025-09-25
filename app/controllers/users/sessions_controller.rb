class Users::SessionsController < DeviseTokenAuth::SessionsController
  # Skip authentication for login actions
  skip_before_action :authenticate_user!, only: [:create, :destroy]
  
  # Override the create action to handle nested session parameters
  def create
    # Flatten the parameters if they come nested in a session object
    if params[:session].present?
      Rails.logger.info "Flattening nested session parameters"
      params[:email] = params[:session][:email]
      params[:password] = params[:session][:password]
    end
    
    Rails.logger.info "Login params: email=#{params[:email]}"
    
    # Call the parent create method which handles token generation
    super
    
    Rails.logger.info "Response headers: #{response.headers.inspect}"
  end
  
  protected

  def sign_in_params
    # DeviseTokenAuth expects flat parameters
    params.permit(:email, :password)
  end

  def resource_params
    sign_in_params
  end
end
