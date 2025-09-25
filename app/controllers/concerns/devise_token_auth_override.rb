module DeviseTokenAuthOverride
  extend ActiveSupport::Concern

  included do
    # Return EXISTING headers without creating new tokens
    def update_auth_header
      return unless @resource && @client_id
      
      # Get the current token data from request headers
      current_token = request.headers['access-token']
      current_client = request.headers['client'] 
      current_uid = request.headers['uid']
      
      return unless current_token && current_client && current_uid
      
      # Return the SAME token that was sent in the request - no rotation
      response.headers['access-token'] = current_token
      response.headers['client'] = current_client
      response.headers['uid'] = current_uid
      response.headers['token-type'] = 'Bearer'
      
      # Get expiry from the stored token
      if @resource.tokens[current_client]
        response.headers['expiry'] = @resource.tokens[current_client]['expiry'].to_s
      end
    end

    # Override batch request validation to always pass
    def ensure_batched_request_consistency
      true
    end
  end
end
