#!/bin/bash

set -e

curl -fsSL -o get-docker.sh https://get.docker.com
sudo sh get-docker.sh
sudo usermod -aG docker $USER
