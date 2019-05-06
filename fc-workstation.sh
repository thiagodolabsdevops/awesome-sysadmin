#!/bin/bash

# Adiciona a chave GPG da UnitedRPMs para o Fedora
rpm --import https://raw.githubusercontent.com/UnitedRPMs/unitedrpms/master/URPMS-GPG-PUBLICKEY-Fedora-24

# Instala e habilita os repositorios da UnitedRPMs
dnf -y install https://github.com/UnitedRPMs/unitedrpms/releases/download/11/unitedrpms-$(rpm -E %fedora)-11.fc$(rpm -E %fedora).noarch.rpm

# Instala e habilita os repositorios da RPM Fusion
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Instala e atualiza os repositorios e aplicativos necessarios para qualquer Workstation multi-purpose funcionar
dnf -y groupinstall "Development Tools"
dnf -y install fedora-workstation-repositories

