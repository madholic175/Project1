# Project Backup Scheme

## Overview
This project is an example project aimed at demonstrating various functionalities and best practices. Further details will be added as the project evolves.

## Installation
Instructions for setting up the project will be updated here.

## Usage
Examples and usage instructions will be provided as the project develops.

## Backup Scheme
To ensure the safety of your project files and changes, an enhanced automatic backup system is implemented:

### Git Version Control
- **Track Changes:** Use `git add .` to stage changes and `git commit -m "Your message"` to save snapshots
- **Revert Changes:** Use `git checkout <commit-hash>` or `git reset` to revert to previous states if needed

### Automatic File Monitoring & Backup System
- **Real-time Monitoring:** Automatically detects file changes using `inotify` and triggers backups
- **Daily Full Backups:** One complete timestamped backup per day stored in `Project1_Backups/full/`
- **Incremental Backups:** Captures recent changes with timestamp, overwrites previous to save space in `Project1_Backups/incremental/`
- **7-Day Retention:** Automatically removes full backups older than 7 days, single incremental backup overwrites itself
- **Smart Debouncing:** Waits for file activity to settle before triggering backup to avoid excessive backups

### Monitor Control Commands
```bash
# Start automatic monitoring
./monitor_control.sh start

# Check monitoring status
./monitor_control.sh status

# Stop monitoring
./monitor_control.sh stop

# Restart monitoring
./monitor_control.sh restart

# Watch live activity
tail -f monitor.log
```

### Backup Structure
```
Project1_Backups/
├── full/
│   └── Project1_Full_YYYYMMDD.tar.gz (timestamped daily backups, 7-day retention)
└── incremental/
    └── Project1_Incremental_YYYYMMDD_HHMMSS.tar.gz (timestamped, overwrites previous)
```

### Backup Behavior
- **Automatic Triggers:** File creation, modification, deletion, or move operations
- **Incremental:** Single timestamped backup, overwrites previous to minimize storage
- **Full Backups:** Timestamped daily, automatically deleted after 7 days
- **Space Efficient:** Maintains maximum 7 full backups + 1 incremental backup
- **Lock Protection:** Prevents multiple simultaneous backups

### Restoring from Backup
- **From Full Backup:** `tar -xzf Project1_Full_YYYYMMDD.tar.gz`
- **From Incremental:** `tar -xzf Project1_Incremental_YYYYMMDD_HHMMSS.tar.gz`

### Manual Backup Option
You can still run manual backups if needed: `./backup_project.sh`

The automatic monitoring system ensures you never lose work due to forgotten manual backups!

## Contributing
Guidelines for contributing to the project will be outlined here.

## Kubernetes Cluster VMs

### VM Configuration
- **k8s-master:** Control plane node (Running ✅)
- **k8s-worker1:** Worker node 1 (Running ✅)
- **k8s-worker2:** Worker node 2 (Running ✅)

### VM Specifications
- **RAM:** 4GB each
- **CPUs:** 2 cores each
- **Disk:** 25GB each
- **OS:** Ubuntu 24.04.2 LTS Server
- **Network:** Dual NIC (NAT + Host-only)

### SSH Access
- **k8s-master:** `ssh -p 2222 k8s-admin@localhost` ✅ **Connected Successfully**
  - Internal IP: 192.168.56.xxx (Host-only)
  - NAT IP: 10.0.2.15
  - Status: Running Ubuntu 24.04.2 LTS, updates available
- **k8s-worker1:** `ssh -p 2223 k8s-admin@localhost` ✅ **Connected Successfully**
  - NAT IP: 10.x.x.x
  - Status: Running Ubuntu 24.04.2 LTS, updates available
- **k8s-worker2:** `ssh -p 2224 k8s-admin@localhost` ✅ **Connected Successfully**
  - NAT IP: 10.0.2.15
  - Status: Running Ubuntu 24.04.2 LTS, updates available

### Connection Testing Results
✅ **k8s-master VM connectivity confirmed**
- SSH authentication working with configured credentials
- Network interfaces properly configured
- System healthy and ready for Kubernetes installation

✅ **k8s-worker1 VM connectivity confirmed**
- SSH authentication working with configured credentials
- NAT networking properly configured
- System healthy and ready for Kubernetes worker node setup

✅ **k8s-worker2 VM connectivity confirmed**
- SSH authentication working with configured credentials
- NAT networking properly configured
- System healthy and ready for Kubernetes worker node setup

🎉 **All 3 VMs operational - Kubernetes cluster infrastructure complete!**

## License
The licensing information will be specified as the project progresses. 