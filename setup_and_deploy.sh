#!/bin/bash

# Update system packages
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Verify Docker installation
docker --version

# Clone the repository
git clone https://github.com/PetrJoe/nginx-docker.git
cd nginx-docker

# Create necessary directories and files
mkdir -p public

# Create a sample index.html file if it doesn't exist
if [ ! -f public/index.html ]; then
  echo "<html><body><h1>Hello from Docker!</h1></body></html>" > public/index.html
fi

# Set the API_URL environment variable
export API_URL=https://nginx-docker-xhl3.onrender.com

# Build the Docker image
docker build -t nginx-app .

# Run the container
docker run -d -p 80:80 -e API_URL=$API_URL --name nginx-container nginx-app

# Display container status
docker ps

echo "Deployment completed successfully!"


#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t nginx-app .

# Run the container, exposing port 80 and setting the API_URL environment variable
docker run -d -p 80:80 -e API_URL=https://nginx-docker-xhl3.onrender.com --name nginx-container nginx-app

# Check if the container is running
docker ps
