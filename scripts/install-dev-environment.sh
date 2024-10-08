#!/bin/bash

set -e

# Add current user to sudoers
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers | sudo visudo -c

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configure Homebrew environment for the current shell
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)" # Apply changes immediately
fi

# Add Oh My Posh to the shell profile if not already present
if ! grep -q 'oh-my-posh init zsh' ~/.zprofile; then
    echo 'eval "$(oh-my-posh init zsh)"' >> ~/.zprofile
fi

echo "Homebrew and Oh My Posh setup completed successfully!"

# Add Meslo Nerd Font
oh-my-posh font install meslo

# Tap the virt-manager repository
brew tap jeffreywildman/homebrew-virt-manager

# Install cask applications
cask_apps=(
    balenaetcher
    cursor
    docker
    logitech-options
    microsoft-remote-desktop
    mongodb-compass 
    ngrok
    obs
    rectangle
    whisky
    zoom
)

echo "Installing cask applications..."
for app in "${cask_apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null; then
        brew install --cask "$app"
    else
        echo "$app is already installed."
    fi
done

# Install command-line tools
cli_tools=(
    awscli
    duf
    helm
    htop
    k9s
    kubernetes-cli
    molten-vk
    oh-my-posh
    qemu
    tree
    sops
    virt-manager
    virt-viewer
)

echo "Installing command-line tools..."
for tool in "${cli_tools[@]}"; do
    if ! brew list "$tool" &>/dev/null; then
        brew install "$tool"
    else
        echo "$tool is already installed."
    fi
done

echo "Development tools installation complete!"

# Check if Cursor command is available
if command -v cursor &>/dev/null; then
    # List of extensions to install
    extensions=(
        "Gydunhn.vsc-essentials"
        "ms-azuretools.vscode-docker"
        "ms-kubernetes-tools.vscode-kubernetes-tools"
        "hashicorp.terraform"
    )

    echo "Installing Cursor extensions..."
    for extension in "${extensions[@]}"; do
        echo "Installing $extension..."
        cursor --install-extension "$extension"
    done

    echo "Cursor extensions have been installed successfully!"
else
    echo "Cursor is not installed. Skipping extensions installation."
fi
