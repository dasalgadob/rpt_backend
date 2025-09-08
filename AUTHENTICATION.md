# Devise Token Auth Integration

## Overview
Successfully integrated devise_token_auth for API authentication in the RPT Backend Rails application.

## What was installed:
1. **Gems added to Gemfile:**
   - `devise` - Base authentication framework
   - `devise_token_auth` - Token-based authentication for APIs

2. **Generated files:**
   - `config/initializers/devise.rb` - Devise configuration
   - `config/initializers/devise_token_auth.rb` - Token auth configuration
   - `db/migrate/20250908202315_devise_token_auth_create_users.rb` - Users table migration
   - `app/models/user.rb` - User model with devise modules
   - Updated `app/controllers/application_controller.rb` - Added SetUserByToken concern

3. **Configuration changes:**
   - Updated `config/application.rb` to enable sessions for API compatibility
   - Updated `config/routes.rb` to mount auth routes at `/auth`
   - CORS already configured to expose auth headers

## Available Endpoints:

### Authentication Endpoints (mounted at `/auth`):
- `POST /auth` - User registration
- `POST /auth/sign_in` - User sign in
- `DELETE /auth/sign_out` - User sign out
- `GET /auth/validate_token` - Validate current token
- `POST /auth/password` - Request password reset
- `PUT /auth/password` - Reset password

### Headers for Authenticated Requests:
When making authenticated requests, include these headers:
- `access-token` - The access token returned from sign in
- `client` - The client identifier returned from sign in  
- `uid` - The user's unique identifier (usually email)

## Example Usage:

### 1. Register a new user:
```bash
curl -X POST http://localhost:3010/auth \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

### 2. Sign in:
```bash
curl -X POST http://localhost:3010/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }' -i
```

### 3. Make authenticated requests:
```bash
curl -X GET http://localhost:3010/companies \
  -H "access-token: YOUR_ACCESS_TOKEN" \
  -H "client: YOUR_CLIENT_ID" \
  -H "uid: user@example.com"
```

## Protected Controllers:
- Added `before_action :authenticate_user!` to `CompaniesController` as an example
- Other controllers can be protected by adding the same before_action

## Authentication Coverage:
🔒 **All API endpoints require authentication by default** except:
- `/auth/*` - All authentication endpoints (sign up, sign in, password reset, etc.)
- `/up` - Rails health check endpoint
- Any endpoint where `public_endpoint?` returns true in the controller

## Protected Controllers:
All controllers inherit authentication from `ApplicationController`:
- CompaniesController
- ProductsController  
- EmployeesController
- PeriodsController
- DepartmentsController
- DimensionsController
- CorporateGoalsController
- DepartmentGoalsController
- PositionGoalsController
- PositionTypesController
- PositionTypeWeightsController
- PositionsController
- EmployeeEvaluationsController
- ProfitReferencesController
- ProfitReferenceHasPositionTypesController
- ReferenceCompensationsController

## Testing:
✅ User registration working (public)
✅ User sign in working (public)
✅ Token validation working (public)
✅ All business endpoints protected
✅ Health check endpoint public
✅ Authentication blocking unauthorized access on all protected endpoints

## Docker Configuration:
- Server runs on port 3010 (mapped from container port 3000)
- Database on port 5434
- All commands should be run using docker-compose

## Making Specific Endpoints Public:
If you need to make specific endpoints public (bypass authentication), you can:

### Option 1: Override in specific controller
```ruby
class YourController < ApplicationController
  private
  
  def public_endpoint?
    action_name == 'index' || action_name == 'show'
  end
end
```

### Option 2: Skip authentication for specific actions
```ruby
class YourController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
end
```

### Option 3: Skip authentication entirely for a controller
```ruby
class PublicController < ApplicationController
  skip_before_action :authenticate_user!
end
```

## Next Steps:
1. Customize User model with additional fields if required
2. Set up proper password reset email configuration for production  
3. Consider adding role-based authorization if needed
4. Add user-company associations if users should be scoped to specific companies
