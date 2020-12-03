#!/bin/bash
TERRAGRUNT_VERSION="v0.26.0"

curl -fsSL -o terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
sudo install terragrunt /usr/local/bin/terragrunt
