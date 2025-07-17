#!/bin/bash

# Enhanced Backup Script for Project1
# - Single incremental backup with timestamp (overwrites previous)
# - Daily full backups with timestamps
# - 7-day retention for full backups

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DATE_ONLY=$(date +%Y%m%d)
BACKUP_DIR="$(dirname "$PWD")/Project1_Backups"
PROJECT_DIR="$PWD"
INCREMENTAL_DIR="$BACKUP_DIR/incremental"
FULL_DIR="$BACKUP_DIR/full"

# Create backup directories if they don't exist
mkdir -p "$INCREMENTAL_DIR" "$FULL_DIR"

# Check if a full backup exists for today
FULL_BACKUP_TODAY="$FULL_DIR/Project1_Full_$DATE_ONLY.tar.gz"

if [ ! -f "$FULL_BACKUP_TODAY" ]; then
    # Create daily full backup with timestamp
    echo "Creating daily full backup: Project1_Full_$DATE_ONLY.tar.gz"
    tar -czf "$FULL_BACKUP_TODAY" -C "$PROJECT_DIR" .
    
    if [ $? -eq 0 ]; then
        echo "Full backup successful: $FULL_BACKUP_TODAY"
    else
        echo "Full backup failed!"
        exit 1
    fi
else
    echo "Full backup for today already exists: $FULL_BACKUP_TODAY"
fi

# Remove any existing incremental backup (only keep one)
rm -f "$INCREMENTAL_DIR"/Project1_Incremental_*.tar.gz

# Create new incremental backup with current timestamp
INCREMENTAL_BACKUP="$INCREMENTAL_DIR/Project1_Incremental_$TIMESTAMP.tar.gz"
echo "Creating incremental backup: Project1_Incremental_$TIMESTAMP.tar.gz"

# Find files modified in the last 24 hours for incremental backup
find "$PROJECT_DIR" -type f -mtime -1 -print0 | tar -czf "$INCREMENTAL_BACKUP" --null -T -

if [ $? -eq 0 ]; then
    echo "Incremental backup successful: $INCREMENTAL_BACKUP"
else
    echo "Incremental backup failed!"
fi

# Cleanup: Remove old full backups (incremental is handled above)
echo "Cleaning up old full backups..."
find "$FULL_DIR" -name "Project1_Full_*.tar.gz" -mtime +7 -exec rm -f {} \;
echo "Backup cleanup completed."

# Display current backup status
echo ""
echo "=== Current Backup Status ==="
echo "Full backups (timestamped, 7-day retention):"
ls -lh "$FULL_DIR"/Project1_Full_*.tar.gz 2>/dev/null || echo "No full backups found"
echo ""
echo "Current incremental backup (single timestamped file):"
ls -lh "$INCREMENTAL_DIR"/Project1_Incremental_*.tar.gz 2>/dev/null || echo "No incremental backup found"
echo ""
echo "Total backup space used:"
du -sh "$BACKUP_DIR" 2>/dev/null || echo "Backup directory not found"

echo ""
echo "=== Usage Notes ==="
echo "- Run this script manually after making changes: ./backup_project.sh"
echo "- Incremental backup is timestamped, always overwrites previous to save space"
echo "- Full backups are timestamped and kept for 7 days"
echo "- Automatic monitoring available with ./monitor_control.sh start" 