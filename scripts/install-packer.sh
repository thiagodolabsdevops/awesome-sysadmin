#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source the OS release information
source /etc/os-release

# Function to install Packer on Debian-based distributions (Ubuntu, Debian)
install_packer_debian() {
    echo "Detected Debian-based distribution ($PRETTY_NAME). Installing Packer..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update
    sudo apt-get install -y packer
}

# Function to install Packer on RHEL-based distributions (CentOS, RHEL)
install_packer_rhel() {
    echo "Detected RHEL-based distribution ($PRETTY_NAME). Installing Packer..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install packer
}

# Function to install Packer on Fedora
install_packer_fedora() {
    echo "Detected Fedora. Installing Packer..."
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf -y install packer
}

# Function to install Packer on Amazon Linux
install_packer_amazon() {
    echo "Detected Amazon Linux. Installing Packer..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install packer
}

# Determine the OS and install Packer accordingly
case "$ID" in
    ubuntu|debian)
        install_packer_debian
        ;;
    centos|rhel)
        install_packer_rhel
        ;;
    fedora)
        install_packer_fedora
        ;;
    amzn)
        install_packer_amazon
        ;;
    *)
        echo "Unsupported Linux distribution: $PRETTY_NAME"
        exit 1
        ;;
esac

echo "Packer installation completed successfully on $PRETTY_NAME."
