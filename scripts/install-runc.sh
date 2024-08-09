#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Source the OS release information
source /etc/os-release

# Function to install runc and podman on Debian-based distributions (Ubuntu, Debian)
install_debian() {
    echo "Detected Debian-based distribution ($PRETTY_NAME). Installing runc and podman..."
    sudo apt-get update
    sudo apt-get install -y runc podman
}

# Function to install runc and podman on RHEL-based distributions (CentOS, RHEL, Amazon Linux)
install_rhel() {
    echo "Detected RHEL-based distribution ($PRETTY_NAME). Installing runc and podman..."
    sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo \
        https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo
    sudo yum -y install yum-utils yum-plugin-copr
    sudo yum -y copr enable lsm5/container-selinux
    sudo yum -y install runc podman
}

# Function to install runc and podman on Fedora
install_fedora() {
    echo "Detected Fedora. Installing runc and podman..."
    sudo dnf install -y dnf-plugins-core
    sudo dnf install -y runc podman
}

# Function to install podman-compose and set up aliases
install_podman_compose() {
    echo "Downloading and installing podman-compose..."
    curl -fsSL -o podman-compose https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py
    sudo install podman-compose /usr/local/bin/

    echo "Setting up aliases..."
    echo 'alias docker="podman"' >> ~/.bashrc
    echo 'alias docker-compose="podman-compose"' >> ~/.bashrc
    source ~/.bashrc

    echo "podman-compose installation and alias setup completed."
}

# Determine the OS and install runc, podman, and podman-compose accordingly
case "$ID" in
    ubuntu|debian)
        install_debian
        ;;
    centos|rhel|amzn)
        install_rhel
        ;;
    fedora)
        install_fedora
        ;;
    *)
        echo "Unsupported Linux distribution: $PRETTY_NAME"
        exit 1
        ;;
esac

# Install podman-compose and set up aliases
install_podman_compose

echo "All installations and configurations are complete!"
