#!/bin/bash
TERRAFORM_VERSION="0.13.5"

curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform.zip
sudo install terraform /usr/local/bin/
