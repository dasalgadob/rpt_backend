#!/bin/bashset -eecho "Starting Rails application..."echo "Environment: $RAILS_ENV"echo "Database URL: $DATABASE_URL"# Ensure SQLite database exists and is migratedif [ ! -f /tmp/app.db ]; then  echo "Creating SQLite database..."  bundle exec rails db:create  bundle exec rails db:migratefi# Start the Rails server
echo "Starting Rails server on port 3000..."
exec bundle exec rails server -b 0.0.0.0 -e production
