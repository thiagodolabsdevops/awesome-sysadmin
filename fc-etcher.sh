#!/bin/bash
# Adicione o repositório do aplicativo

wget https://etcher.io/static/etcher-rpm.repo -O /etc/yum.repos.d/etcher-rpm.repo 

# Instale o Etcher

dnf install -y etcher-electron
