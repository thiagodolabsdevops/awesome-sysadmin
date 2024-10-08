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

# Install Minikube
install_minikube() {
    local minikube_binary="minikube"
    download_file "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" "$minikube_binary"
    
    echo "Installing Minikube..."
    sudo install "$minikube_binary" /usr/local/bin/
    
    echo "Minikube installation completed."
}

# Install kubectl
install_kubectl() {
    local kubectl_url="https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    local kubectl_binary="kubectl"
    
    download_file "$kubectl_url" "$kubectl_binary"
    
    echo "Installing kubectl..."
    sudo install "$kubectl_binary" /usr/local/bin/
    
    echo "kubectl installation completed."
    
    # Set up aliases for kubectl
    echo "Creating aliases for kubectl..."
    echo 'alias k="kubectl"' >> ~/.bashrc
    echo 'alias kctx="kubectl config use-context"' >> ~/.bashrc
    echo 'alias kns="kubectl config set-context --current --namespace"' >> ~/.bashrc
    source ~/.bashrc
    echo "kubectl aliases added."
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
install_minikube
install_kubectl
install_helm

echo "All installations and configurations are complete!"
echo "You can start Minikube using: minikube start"
echo "You can open the Minikube dashboard using: minikube dashboard"