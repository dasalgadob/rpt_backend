class Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # Skip authentication for login actions
  skip_before_action :authenticate_user!, only: [:create, :destroy]
  
  private

  def respond_with(current_user, _opts = {})
    if current_user.persisted?
      render json: {
        status: {
          code: 200, message: 'Logged in successfully.',
          data: { user: current_user }
        }
      }, status: :ok
    else
      render json: {
        status: {
          message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.jwt_secret_key || '465114a491d54b5740076fb8df2e6942765315eda019bca5f4f37359701aed148f8b3cfa73035a0becaf7ee350392c013fef360a7c7cd4edce0674cbfea6ae02').first
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
