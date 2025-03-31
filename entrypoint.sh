#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for PostgreSQL to be ready
until pg_isready -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USERNAME
do
  echo "Waiting for PostgreSQL..."
  sleep 2
done
echo "PostgreSQL is ready!"

# Setup the database if it doesn't exist
bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
