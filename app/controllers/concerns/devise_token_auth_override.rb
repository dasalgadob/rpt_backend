module DeviseTokenAuthOverride
  extend ActiveSupport::Concern

  included do
    # NUCLEAR OPTION: Completely prevent any token changes
    def update_auth_header
      # DO ABSOLUTELY NOTHING - freeze the tokens completely
      return
    end

    # Override batch request validation to always allow token reuse
    def ensure_batched_request_consistency
      # Always return true - never invalidate tokens
      true
    end

    # Override token validation to always accept existing tokens
    def valid_token?(token, client_id = nil)
      return false unless @resource && token && client_id
      
      # Just check if token exists, don't rotate it
      @resource.tokens.has_key?(client_id) && 
      @resource.tokens[client_id]['token'] == token
    end
  end
end
