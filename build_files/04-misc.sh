#!/bin/bash

set -ouex pipefail

ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/nvim /usr/bin/vi

# Enable systemd services
# activate podman timer for root user
# activate podman auto update for all normal users
systemctl enable podman-auto-update.timer
systemctl --global enable podman-auto-update.timer

sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
