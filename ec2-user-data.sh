#!/bin/bash
# EC2 User Data Script - Wedding Gamification App
# Installs Docker, Nginx, and prepares app directory

set -e

# Log everything
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Starting EC2 Setup at $(date) ==="

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
echo "=== Installing Docker ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ubuntu

# Install Docker Compose
echo "=== Installing Docker Compose ==="
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Nginx
echo "=== Installing Nginx ==="
apt-get install -y nginx

# Configure Nginx as reverse proxy
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Restart Nginx
systemctl restart nginx
systemctl enable nginx

# Create app directory
echo "=== Creating app directory ==="
mkdir -p /home/ubuntu/wedding-game
chown ubuntu:ubuntu /home/ubuntu/wedding-game

# Install Node.js (for debugging if needed)
echo "=== Installing Node.js ==="
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

echo "=== Setup complete at $(date) ==="
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Node version: $(node --version)"
echo "Nginx status: $(systemctl is-active nginx)"
