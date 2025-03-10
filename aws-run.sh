#!/bin/bash
# Set the password for the "ec2-user"
echo "ec2-user:YourSecurePassword" | sudo chpasswd

# Enable password authentication in SSH
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

# Ensure UsePAM is enabled
echo "UsePAM yes" | sudo tee -a /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart sshd
