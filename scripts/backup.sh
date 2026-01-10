#!/bin/bash
BACKUP_DIR="$HOME/adguard-backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"
sudo tar -czf "$BACKUP_DIR/adguard_backup_$DATE.tar.gz" -C /opt/AdGuardHome AdGuardHome.yaml data/
