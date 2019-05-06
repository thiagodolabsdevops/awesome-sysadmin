# Install Docker dependencies and repositories
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Add your user to the "docker" group to use Docker as a non-root user
# usermod -aG docker your-user
