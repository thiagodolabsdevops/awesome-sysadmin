#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to download a file and check if the download was successful
download_file() {
    local url=$1
    local output=$2

    echo "Downloading $output from $url..."
    if curl -fsSL -o "$output" "$url"; then
        echo "$output downloaded successfully."
    else
        echo "Failed to download $output from $url." >&2
        exit 1
    fi
}

# Install Docker
install_docker() {
    local docker_script="get-docker.sh"
    download_file "https://get.docker.com" "$docker_script"
    
    echo "Running Docker installation script..."
    sudo sh "$docker_script"
    
    echo "Adding $USER to the docker group..."
    sudo usermod -aG docker "$USER"
    
    echo "Docker installation completed."
}

# Enable Docker's Kubernetes
enable_docker_kubernetes() {
    echo "Enabling Docker's built-in Kubernetes..."
    
    # Create Docker's daemon.json if it doesn't exist
    if [ ! -f /etc/docker/daemon.json ]; then
        echo "{}" | sudo tee /etc/docker/daemon.json > /dev/null
    fi
    
    # Enable Kubernetes in Docker
    sudo jq '. + {"kubernetes": {"enabled": true}}' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json > /dev/null
    
    # Restart Docker to apply changes
    echo "Restarting Docker to apply Kubernetes changes..."
    sudo systemctl restart docker
    
    echo "Docker's Kubernetes is now enabled."
}

# Install kubectl
install_kubectl() {
    local kubectl_url="https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    local kubectl_binary="kubectl"
    
    download_file "$kubectl_url" "$kubectl_binary"
    
    echo "Installing kubectl..."
    sudo install "$kubectl_binary" /usr/local/bin/
    
    echo "kubectl installation completed."
}

# Install Helm
install_helm() {
    local helm_script="get_helm.sh"
    download_file "https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3" "$helm_script"
    
    echo "Running Helm installation script..."
    sudo sh "$helm_script"
    
    echo "Helm installation completed."
}

# Run installation functions
install_docker
enable_docker_kubernetes
install_kubectl
install_helm

echo "All installations and configurations are complete!"
