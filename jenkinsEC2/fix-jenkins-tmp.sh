#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

NEW_TMP_DIR="/var/cache/jenkins/tmp"

echo "1. Creating new Jenkins tmp directory at $NEW_TMP_DIR..."
sudo mkdir -p "$NEW_TMP_DIR"
sudo chown -R jenkins:jenkins /var/cache/jenkins

echo "2. Creating systemd drop-in override for Jenkins..."
sudo mkdir -p /etc/systemd/system/jenkins.service.d
sudo tee /etc/systemd/system/jenkins.service.d/override.conf > /dev/null <<EOF
[Service]
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.io.tmpdir=$NEW_TMP_DIR"
EOF

echo "3. Reloading systemd daemon to apply changes..."
sudo systemctl daemon-reload

echo "4. Resetting failed state and restarting Jenkins..."
sudo systemctl reset-failed jenkins
sudo systemctl restart jenkins

echo "Done! Verifying disk space on the new directory:"
df -h "$NEW_TMP_DIR"

echo "Jenkins service status:"
sudo systemctl status jenkins --no-pager | grep Active

