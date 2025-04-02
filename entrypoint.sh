#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USERNAME" -d "$DATABASE_NAME"
do
  echo "db:$DATABASE_PORT - no response"
  echo "Waiting for PostgreSQL..."
  sleep 2
done
echo "PostgreSQL is ready!"

# Create and migrate the database
echo "Running database migrations..."
bundle exec rails db:migrate RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
