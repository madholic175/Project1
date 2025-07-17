#!/bin/bash

# Automatic File Monitor for Project1
# Watches for file changes and automatically triggers backups
# Uses inotify-tools to monitor filesystem events

PROJECT_DIR="$(pwd)"
BACKUP_SCRIPT="$PROJECT_DIR/backup_project.sh"
LOCK_FILE="/tmp/project1_backup.lock"
LOG_FILE="$PROJECT_DIR/monitor.log"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to run backup with lock to prevent multiple simultaneous backups
run_backup() {
    if [ -f "$LOCK_FILE" ]; then
        log_message "Backup already in progress, skipping..."
        return
    fi
    
    # Create lock file
    touch "$LOCK_FILE"
    
    log_message "File changes detected, running backup..."
    
    # Run the backup script and capture output
    if "$BACKUP_SCRIPT" >> "$LOG_FILE" 2>&1; then
        log_message "Backup completed successfully"
    else
        log_message "Backup failed!"
    fi
    
    # Remove lock file
    rm -f "$LOCK_FILE"
}

# Function to cleanup on exit
cleanup() {
    log_message "File monitor stopping..."
    rm -f "$LOCK_FILE"
    exit 0
}

# Trap signals for clean shutdown
trap cleanup SIGINT SIGTERM

# Start monitoring
log_message "Starting file monitor for Project1..."
log_message "Monitoring directory: $PROJECT_DIR"
log_message "Press Ctrl+C to stop monitoring"

# Monitor for file events (modify, create, delete, move)
# Exclude backup files and logs to prevent recursive monitoring
inotifywait -m -r -e modify,create,delete,move \
    --exclude '(\.tar\.gz$|monitor\.log$|\.git/|Project1_Backups/)' \
    "$PROJECT_DIR" |
while read path action file; do
    log_message "Detected $action on $file in $path"
    
    # Debounce rapid changes (wait 2 seconds for additional changes)
    sleep 2
    
    # Check if there are any pending inotify events
    if ! timeout 1 inotifywait -q -t 1 -r -e modify,create,delete,move \
        --exclude '(\.tar\.gz$|monitor\.log$|\.git/|Project1_Backups/)' \
        "$PROJECT_DIR" 2>/dev/null; then
        # No more events, safe to backup
        run_backup
    else
        log_message "More changes detected, waiting for activity to settle..."
    fi
done 