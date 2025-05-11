#!/bin/bash

# Create backup directory if it doesn't exist
mkdir -p ~/db_backups

# Get the PostgreSQL container ID
CONTAINER_ID=$(docker ps --filter "name=db" --format "{{.ID}}")

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Could not find PostgreSQL container"
    exit 1
fi

# Create backup filename with timestamp
BACKUP_FILE="~/db_backups/backup_$(date +%Y%m%d_%H%M%S).sql"

# Create the backup
echo "Creating database backup..."
docker exec $CONTAINER_ID pg_dump -U tuiter_app tuiter_app_production > $BACKUP_FILE

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
    # List the backup file
    ls -lh $BACKUP_FILE
else
    echo "Backup failed!"
    exit 1
fi
