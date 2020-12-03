#!/bin/bash

set -e

curl -fsSL -o minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/

# minikube start
# minikube dashboard
