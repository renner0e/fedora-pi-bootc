#!/bin/bash

set -ouex pipefail

echo "::group:: Installing Packages"

sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo

dnf -y install dnf5-plugins

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 -y copr enable ublue-os/packages

dnf -y remove \
  vim-minimal

dnf -y install \
  borgbackup \
  btop \
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
  usbutils \
  ublue-os-signing \
  wget \
  wireguard-tools \
  zram-generator-defaults \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

echo "::endgroup::"

