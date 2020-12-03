# !/bin/bash

set -e

NVIDIA_VERSION=418.56

curl -fsSL http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
sudo chmod +x NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
sudo sh NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
