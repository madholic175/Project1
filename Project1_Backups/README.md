# Backup Directory Structure

This directory demonstrates the automated backup system organization.

## Directory Layout:
```
Project1_Backups/
├── full/
│   └── Project1_Full_YYYYMMDD.tar.gz (daily backups, 7-day retention)
└── incremental/
    └── Project1_Incremental_YYYYMMDD_HHMMSS.tar.gz (latest changes)
```

## How It Works:
- **Full Backups:** Created daily with timestamp, automatically deleted after 7 days
- **Incremental Backups:** Single timestamped file that captures recent changes
- **Automatic Triggers:** File monitoring detects changes and triggers backups
- **Space Efficient:** Maintains max 7 full + 1 incremental backup

## Usage:
- Manual backup: `./backup_project.sh`
- Start monitoring: `./monitor_control.sh start`
- View status: `./monitor_control.sh status`

## Note:
Actual backup files (.tar.gz) are excluded from git repository for privacy and size considerations.
The backup system creates real compressed archives locally for data protection. 