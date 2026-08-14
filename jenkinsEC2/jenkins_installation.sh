#!/bin/bash

echo "Starting Jenkins Installation..."

# 1. Update the system packages
sudo dnf update -y

# 2. Install Java 21 and fontconfig (Crucial fixes for AL2023)
# - Java 21 is the new strict requirement for latest Jenkins
# - fontconfig is required by Java AWT to prevent instant UI crashes
sudo dnf install -y java-21-amazon-corretto fontconfig

# 3. Add the official Jenkins repository and GPG key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# 4. Install Jenkins
sudo dnf install -y jenkins

# 5. Enable systemd to start Jenkins automatically on reboot, and start it now
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 6. Wait a moment for Jenkins to generate the password file
echo "Waiting for Jenkins to boot and generate the admin password..."
sleep 15

# 7. Print the password to the screen
echo "==================================================="
echo "Jenkins is running! Your Initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "==================================================="
