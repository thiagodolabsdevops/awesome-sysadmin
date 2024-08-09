#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to get the latest Nvidia driver version for Linux
get_latest_nvidia_version() {
    echo "Fetching the latest Nvidia driver version..."
    
    # Get the JSON data for the latest Linux driver release from Nvidia's website
    latest_version=$(curl -s https://www.nvidia.com/en-us/drivers/unix/ | \
    grep -oP '"Linux_x86_64":"\d+\.\d+"(,"Linux_aarch64")?' | \
    grep -oP '\d+\.\d+' | sort -V | tail -1)
    
    if [ -z "$latest_version" ]; then
        echo "Failed to fetch the latest Nvidia driver version." >&2
        exit 1
    fi
    
    echo "Latest Nvidia driver version: $latest_version"
    echo $latest_version
}

# Download and install the Nvidia driver
install_nvidia_driver() {
    local nvidia_version=$1
    local nvidia_installer="NVIDIA-Linux-x86_64-${nvidia_version}.run"
    local nvidia_url="http://us.download.nvidia.com/XFree86/Linux-x86_64/${nvidia_version}/${nvidia_installer}"

    echo "Downloading Nvidia driver version $nvidia_version..."
    curl -fsSL -O "$nvidia_url"
    
    echo "Making the installer executable..."
    sudo chmod +x "$nvidia_installer"
    
    echo "Running the Nvidia installer..."
    sudo sh "$nvidia_installer"
    
    echo "Nvidia driver installation completed."
}

# Get the latest Nvidia driver version
latest_version=$(get_latest_nvidia_version)

# Install the Nvidia driver
install_nvidia_driver "$latest_version"
