#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to get the latest version of Terraform
get_latest_terraform_version() {
    echo "Fetching the latest Terraform version..."
    latest_version=$(curl -s https://releases.hashicorp.com/terraform/ | \
    grep -oP '(?<=href=")[0-9.]+(?=/")' | sort -V | tail -n 1)
    
    if [ -z "$latest_version" ]; then
        echo "Failed to fetch the latest Terraform version." >&2
        exit 1
    fi
    
    echo "Latest Terraform version: $latest_version"
    echo $latest_version
}

# Function to get the latest version of Terragrunt
get_latest_terragrunt_version() {
    echo "Fetching the latest Terragrunt version..."
    latest_version=$(curl -s https://github.com/gruntwork-io/terragrunt/releases | \
    grep -oP '(?<=/download/)[^/]+(?=")' | grep -v 'rc' | sort -V | tail -n 1)
    
    if [ -z "$latest_version" ]; then
        echo "Failed to fetch the latest Terragrunt version." >&2
        exit 1
    fi
    
    echo "Latest Terragrunt version: $latest_version"
    echo $latest_version
}

# Get the latest versions
TERRAFORM_VERSION=$(get_latest_terraform_version)
TERRAGRUNT_VERSION=$(get_latest_terragrunt_version)

# Download and install Terraform
terraform_zip="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
terraform_url="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${terraform_zip}"
echo "Downloading Terraform version $TERRAFORM_VERSION..."
curl -fsSL -o "$terraform_zip" "$terraform_url"
unzip -o "$terraform_zip"
sudo install terraform /usr/local/bin/
rm "$terraform_zip"
rm terraform

# Download and install Terragrunt
terragrunt_url="https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
echo "Downloading Terragrunt version $TERRAGRUNT_VERSION..."
curl -fsSL -o terragrunt "$terragrunt_url"
sudo install terragrunt /usr/local/bin/
rm terragrunt

echo "Terraform and Terragrunt installation completed successfully!"
