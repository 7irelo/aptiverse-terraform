#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ubuntu

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create application directory
mkdir -p /opt/aptiverse

# Create systemd service for the application
cat > /etc/systemd/system/aptiverse.service << EOF
[Unit]
Description=Aptiverse Application
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/aptiverse
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
EOF

systemctl enable aptiverse.service

# Create docker-compose file
cat > /opt/aptiverse/docker-compose.yml << EOF
version: '3.8'
services:
  app:
    image: aptiverse/app:latest
    container_name: aptiverse-app
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=${db_host}
      - DB_USER=${db_user}
      - DB_PASSWORD=${db_password}
      - DB_NAME=${db_name}
    volumes:
      - ./logs:/app/logs
EOF

echo "User data script completed for environment: ${environment}"