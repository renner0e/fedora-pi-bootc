#!/bin/bash

set -ouex pipefail

# Disable all COPRs and RPM Fusion Repos and terra
dnf5 -y copr disable ublue-os/packages
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo

# Cleanup
# Remove tmp files and everything in dirs that make bootc unhappy
rm -rf /tmp/* || true
rm -rf /usr/etc
rm -rf /boot && mkdir /boot
# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;

#find /var -mindepth 1 -delete
#find /boot -mindepth 1 -delete

#rm -rf /var /boot
#mkdir -p /var /boot

# Make /usr/local writeable
ln -s /var/usrlocal /usr/local
