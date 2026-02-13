#!/usr/bin/env bash
set -euo pipefail

# Install MySQL Server 8.0.41 on Ubuntu 20.04 (Focal)
# Requires sudo privileges.

sudo apt-get update
sudo apt-get install -y wget gnupg lsb-release ca-certificates

# Refresh MySQL repo key (fixes EXPKEYSIG)
sudo install -d -m 0755 /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/mysql.gpg https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

# Add MySQL APT repo config
wget -O /tmp/mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.33-1_all.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config.deb

sudo apt-get update

# Install exact version 8.0.41 (Ubuntu 20.04 build)
sudo apt-get install -y mysql-server=8.0.41-1ubuntu20.04

# Prevent auto-upgrades
sudo apt-mark hold mysql-server mysql-client mysql-common

# Verify
mysql --version
