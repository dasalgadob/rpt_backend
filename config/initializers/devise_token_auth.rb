# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  # COMPLETELY DISABLE TOKEN ROTATION - Most aggressive approach
  config.change_headers_on_each_request = false
  
  # Long token lifespan to prevent automatic rotation
  config.token_lifespan = 1.year
  
  # Prevent token changes in production
  config.headers_names = {
    :'authorization' => 'Authorization',
    :'access-token' => 'access-token', 
    :'client' => 'client',
    :'expiry' => 'expiry',
    :'uid' => 'uid',
    :'token-type' => 'token-type'
  }

  # Limiting the token_cost to just 4 in testing will increase the performance of
  # your test suite dramatically. The possible cost value is within range from 4
  # to 31. It is recommended to not use a value more than 10 in other environments.
  config.token_cost = Rails.env.test? ? 4 : 10

  # Allow unlimited devices to prevent token cleanup
  config.max_number_of_devices = 1000
  
  # Very long batch request buffer to prevent token rotation
  config.batch_request_buffer_throttle = 5.minutes

  # This route will be the prefix for all oauth2 redirect callbacks. For
  # example, using the default '/omniauth', the github oauth2 provider will
  # redirect successful authentications to '/omniauth/github/callback'
  # config.omniauth_prefix = "/omniauth"

  # By default sending current password is not needed for the password update.
  # Uncomment to enforce current_password param to be checked before all
  # attribute updates. Set it to :password if you want it to be checked only if
  # password is updated.
  # config.check_current_password_before_update = :attributes

  # By default we will use callbacks for single omniauth.
  # It depends on fields like email, provider and uid.
  # config.default_callbacks = true

  # Makes it possible to change the headers names
  # config.headers_names = {
  #   :'authorization' => 'Authorization',
  #   :'access-token' => 'access-token',
  #   :'client' => 'client',
  #   :'expiry' => 'expiry',
  #   :'uid' => 'uid',
  #   :'token-type' => 'token-type'
  # }

  # Makes it possible to use custom uid column
  # config.other_uid = "foo"

  # By default, only Bearer Token authentication is implemented out of the box.
  # If, however, you wish to integrate with legacy Devise authentication, you can
  # do so by enabling this flag. NOTE: This feature is highly experimental!
  # config.enable_standard_devise_support = false

  # By default DeviseTokenAuth will not send confirmation email, even when including
  # devise confirmable module. If you want to use devise confirmable module and
  # send email, set it to true. (This is a setting for compatibility)
  # config.send_confirmation_email = true

  # Additional stability settings
  # Increase token lifespan if needed (default is 2 weeks)
  # config.token_lifespan = 1.month

  # Disable token recycling on failed requests
  config.remove_tokens_after_password_reset = false
  
  # Additional anti-rotation settings
  config.default_confirm_success_url = nil
  config.default_password_reset_url = nil
  
  # Override environment-specific settings if needed
  if Rails.env.production? || Rails.env.development?
    # Force same settings everywhere
    config.batch_request_buffer_throttle = 10.minutes
    config.max_number_of_devices = 1000
    config.token_lifespan = 1.year
  end
end
