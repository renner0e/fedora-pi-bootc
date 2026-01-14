#!/bin/bash

set -ouex pipefail

cp -avf "/ctx/files"/. /

echo "::group:: Installing Packages"

sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo

dnf -y install dnf5-plugins

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo

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
  nvim \
  rclone \
  slirp4netns \
  smartmontools \
  systemd-container \
  tailscale \
  tmux \
  traceroute \
  tree \
  usbutils \
  wget \
  wireguard-tools \
  zram-generator-defaults

dnf5 -y remove \
  adcli \
  adwaita* \
  flatpak-session-helper \
  fwupd* \
  nano \
  nfs-utils \
  nvidia-gpu-firmware \
  python3-botocore \
  qemu-user-static \
  samba* \
  sssd \
  toolbox \
  tpm2-tools \
  wcurl \
  xkeyboard-config

rm -rf /usr/share/doc

echo "::endgroup::"

