#!/bin/bash

set -ouex pipefail

# Disable all COPRs and RPM Fusion Repos and terra
dnf5 -y copr disable ublue-os/packages
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo

dnf clean all

#find /var -mindepth 1 -delete
#find /boot -mindepth 1 -delete

#rm -rf /var /boot
#mkdir -p /var /boot

# Make /usr/local writeable
ln -s /var/usrlocal /usr/local
