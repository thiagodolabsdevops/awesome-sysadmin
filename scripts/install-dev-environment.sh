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
    microsoft-remote-desktop
    balenaetcher
    ngrok
    docker
    visual-studio-code
    obs
    logitech-options
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
    helm
    kubernetes-cli
    tree
    htop
    sops
    awscli
    qemu
    virt-manager
    virt-viewer
    oh-my-posh
    k9s
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

# Check if VSCode command is available
if command -v code &>/dev/null; then
    # List of extensions to install
    extensions=(
        "Gydunhn.vsc-essentials"
        "ms-azuretools.vscode-docker"
        "ms-kubernetes-tools.vscode-kubernetes-tools"
        "hashicorp.terraform"
    )

    echo "Installing VSCode extensions..."
    for extension in "${extensions[@]}"; do
        echo "Installing $extension..."
        code --install-extension "$extension"
    done

    echo "VSCode extensions have been installed successfully!"
else
    echo "VSCode is not installed. Skipping extensions installation."
fi
