# Production JWT Migration Guide

This guide contains all the commands needed to migrate from devise_token_auth to devise-jwt in production.

## Prerequisites

Before running these commands in production:
1. Create a full database backup
2. Test all commands in a staging environment first
3. Schedule a maintenance window for the migration
4. Prepare to rollback if needed

## Migration Steps

### 1. Update Gemfile and Install Dependencies

**Command:**
```bash
# In production server (using your deployment method)
docker-compose exec web bundle install
```

**Expected Output:** Bundle install will add devise-jwt and its dependencies.

### 2. Generate JWT Secret Key

**Command:**
```bash
docker-compose exec web bundle exec rails secret
```

**Expected Output:** A long secret key string (save this for step 4)

### 3. Remove devise_token_auth Initializer (if exists)

**Command:**
```bash
rm config/initializers/devise_token_auth.rb
```

**Note:** This file may not exist if already removed.

### 4. Generate JWT Denylist Migration

**Command:**
```bash
docker-compose exec web bundle exec rails generate migration CreateJwtDenylist jti:string:index exp:datetime
```

**Expected Output:** Creates a migration file in db/migrate/

### 5. Run Database Migration

**Command:**
```bash
docker-compose exec web bundle exec rails db:migrate
```

**Expected Output:** Creates the jwt_denylist table with proper indexes.

### 6. Restart Application

**Command:**
```bash
docker-compose restart web
```

**Expected Output:** Application restarts successfully with new JWT authentication.

## Testing the Migration

### 1. Test User Login

**Command:**
```bash
curl -X POST http://your-domain/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@example.com","password":"password"}}'
```

**Expected Response:**
```json
{
  "status": {
    "code": 200,
    "message": "Logged in successfully.",
    "data": {
      "user": {
        "id": 1,
        "email": "test@example.com",
        ...
      }
    }
  }
}
```

**Look for:** JWT token in the `Authorization` header of the response.

### 2. Test Authenticated Request

**Command:**
```bash
curl -X GET http://your-domain/protected-endpoint \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

**Expected Response:** Successful response from protected endpoint.

### 3. Test User Logout

**Command:**
```bash
curl -X DELETE http://your-domain/auth/sign_out \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

**Expected Response:**
```json
{
  "status": 200,
  "message": "Logged out successfully."
}
```

## Configuration Details

### JWT Secret Key Configuration

The JWT secret is configured in `config/initializers/devise.rb`:

```ruby
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.jwt_secret_key || 'FALLBACK_SECRET_FROM_STEP_2'
  jwt.dispatch_requests = [
    ['POST', %r{^/auth/sign_in$}]
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/auth/sign_out$}]
  ]
  jwt.expiration_time = 1.day.to_i
end
```

### API Endpoints

After migration, the authentication endpoints are:

- **Login:** `POST /auth/sign_in`
- **Logout:** `DELETE /auth/sign_out`
- **Register:** `POST /auth` (if registration is enabled)

### JWT Token Usage

- JWT tokens are returned in the `Authorization` header as: `Bearer <token>`
- Clients should include this header in all authenticated requests
- Tokens expire after 1 day (configurable)
- Logged out tokens are added to the denylist for security

## Rollback Plan (If Needed)

If the migration fails and you need to rollback:

1. **Restore Database Backup:**
   ```bash
   # Restore your database backup
   docker-compose exec db pg_restore -d your_database backup_file.sql
   ```

2. **Revert Gemfile:**
   ```bash
   # Re-add devise_token_auth to Gemfile
   # Remove devise-jwt from Gemfile
   docker-compose exec web bundle install
   ```

3. **Restore devise_token_auth Configuration:**
   ```ruby
   # In config/routes.rb
   mount_devise_token_auth_for 'User', at: 'auth'
   
   # Restore devise_token_auth initializer if needed
   ```

4. **Restart Application:**
   ```bash
   docker-compose restart web
   ```

## Environment Variables (Optional)

For better security, store the JWT secret in environment variables:

```bash
# Add to your environment variables
JWT_SECRET_KEY=your_generated_secret_from_step_2
```

Then update `config/initializers/devise.rb`:
```ruby
jwt.secret = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key
```

## Monitoring and Verification

After migration, monitor these metrics:

1. **Application Logs:** Check for JWT-related errors
2. **Authentication Success Rate:** Monitor login/logout success
3. **Token Denylist Growth:** Monitor jwt_denylist table size
4. **API Response Times:** Ensure no performance degradation

## Cleanup Tasks (Optional)

After confirming the migration is successful, you can clean up:

1. **Remove devise_token_auth columns from users table** (create migration):
   - `tokens` (json)
   - `provider` (if not used elsewhere)
   - `uid` (if not used elsewhere)
   - Other devise_token_auth specific columns

2. **Remove old token-based authentication logic** from frontend applications

## Support and Troubleshooting

Common issues and solutions:

1. **"JWT token is invalid":** Check JWT secret configuration
2. **"Couldn't find an active session":** Ensure proper Authorization header format
3. **Database migration fails:** Check for conflicts with existing tables

For additional support, check the application logs and the devise-jwt documentation.

---

**Migration completed on:** [DATE]
**Migrated by:** [YOUR_NAME]
**Production environment:** [ENVIRONMENT_NAME]
