#!/bin/bash

set -ouex pipefail

# Disable all COPRs and RPM Fusion Repos and terra
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo

# Revert back to upstream defaults
dnf config-manager setopt keepcache=0

# Cleanup
# Remove tmp files and everything in dirs that make bootc unhappy
rm -rf /tmp/* || true
rm -rf /usr/etc
rm -rf /boot && mkdir /boot

#find /var -mindepth 1 -delete
#find /boot -mindepth 1 -delete

#rm -rf /var /boot
#mkdir -p /var /boot

# Make /usr/local writeable
ln -s /var/usrlocal /usr/local
