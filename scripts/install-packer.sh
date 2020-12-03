#!/bin/bash

set -e

source /etc/os-release

if [ $PRETTY_NAME =~ "Ubuntu" || $PRETTY_NAME =~ "Debian" ]; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get install packer
fi

if [ $PRETTY_NAME =~ "CentOS" || $PRETTY_NAME =~ "RHEL" ]; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install packer
fi

if [ $PRETTY_NAME =~ "Fedora" ]; then
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf -y install packer
fi

if [ $PRETTY_NAME =~ "Amazon Linux" ]; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install packer
fi
