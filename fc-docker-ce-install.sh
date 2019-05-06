# !/bin/bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh


# Install Docker dependencies and repositories
# dnf -y install dnf-plugins-core
# dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# dnf -y install docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add your user to the "docker" group to use Docker as a non-root user
# usermod -aG docker your-user
