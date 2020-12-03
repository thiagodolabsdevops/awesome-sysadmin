#!/bin/bash

set -e

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo sh get_helm.sh
