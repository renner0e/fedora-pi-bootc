#!/bin/bash

set -ouex pipefail

sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo

dnf -y install dnf5-plugins

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 -y copr enable ublue-os/packages

dnf -y remove \
  vim-minimal

dnf -y install \
  NetworkManager-wifi \
  borgbackup \
  btop \
  cockpit \
  cockpit-bridge \
  cockpit-navigator \
  cockpit-networkmanager \
  cockpit-podman \
  cockpit-selinux \
  cockpit-storaged \
  cockpit-system \
  cockpit-ws \
  distrobox \
  fastfetch \
  fzf \
  git \
  greenboot \
  greenboot-default-health-checks \
  hdparm \
  htop \
  iwd \
  just \
  lshw \
  man-db \
  man-pages \
  neovim \
  net-tools \
  ntfs-3g \
  ntfsprogs \
  nvme-cli \
  rclone \
  samba \
  samba-usershares \
  slirp4netns \
  smartmontools \
  speedtest-cli \
  systemd-container \
  tailscale \
  tldr \
  tmux \
  traceroute \
  tree \
  ublue-brew \
  usbutils \
  wget \
  wireguard-tools \
  zram-generator-defaults \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zstd

ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/nvim /usr/bin/vi

systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer


# Enable systemd services
# activate podman timer for root user
# activate podman auto update for all normal users
systemctl enable podman-auto-update.timer
systemctl --global enable podman-auto-update.timer
