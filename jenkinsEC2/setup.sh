#!/bin/bash

echo "=========================================="
echo " Starting Complete AL2023 Setup Script"
echo "=========================================="

# 1. System Updates
echo "[1/5] Updating system packages..."
sudo dnf update -y

# 2. Install Docker
echo "[2/5] Installing Docker..."
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
# Grant standard user permission to run docker commands
sudo usermod -aG docker ec2-user

# 3. Install Core Dependencies (Java 21, fontconfig, Git, Node.js, and npm)
echo "[3/5] Installing Java 21, Git, Node.js, and fontconfig..."
sudo dnf install -y java-21-amazon-corretto fontconfig git nodejs

# 4. Install Jenkins
echo "[4/5] Installing Jenkins..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins

# Reload systemd and start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Grant Jenkins permission to build Docker containers in pipelines
sudo usermod -aG docker jenkins

# 5. Output Versions & Jenkins Password
echo "[5/5] Setup Complete! Verifying installations:"
echo "------------------------------------------"
docker --version
node -v
npm -v
java -version
echo "------------------------------------------"

echo "Waiting for Jenkins to generate admin password..."
sleep 15
echo "==================================================="
echo " Jenkins is running! Your Initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "==================================================="

# Install Pip 
sudo dnf install -y python3-pip
