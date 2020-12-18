#!/bin/bash

set -e

source /etc/os-release

if [ $PRETTY_NAME =~ "Ubuntu" || $PRETTY_NAME =~ "Debian" ]; then
    sudo apt-get update && sudo apt install -y runc podman
fi

if [ $PRETTY_NAME =~ "CentOS" || $PRETTY_NAME =~ "RHEL" || $PRETTY_NAME =~ "Amazon Linux" ]; then
    sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo
    sudo yum -y install yum-utils yum-plugin-copr
    sudo yum -y copr enable lsm5/container-selinux
    sudo yum -y install runc podman
fi

if [ $PRETTY_NAME =~ "Fedora" ]; then
    sudo dnf install -y dnf-plugins-core
    sudo dnf install -y runc podman
fi

curl -fsSL -o podman-compose https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py
sudo install podman-compose /usr/local/bin/

echo 'alias docker="podman"' >> ~/.bashrc
echo 'alias docker-compose="podman-compose"' >> ~/.bashrc
source ~/.bashrc
