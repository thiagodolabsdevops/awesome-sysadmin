# !/bin/bash
# Register the Microsoft Red Hat repository
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo

# Install PowerShell
dnf -y install powershell

# Start PowerShell
# pwsh
