#!/bin/bash

set -ouex pipefail

cp -avf "/ctx/files"/. /


sed -i "s/enabled=1/enabled=0/" /etc/yum.repos.d/fedora-cisco-openh264.repo

dnf -y install 'dnf5-command(config-manager)'

cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
dnf config-manager setopt keepcache=1 timeout=60

dnf -y install --setopt=install_weak_deps=False \
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
  man-pages \
  rclone \
  rsync \
  slirp4netns \
  smartmontools \
  systemd-boot-unsigned \
  systemd-container \
  tailscale \
  tmux \
  traceroute \
  tree \
  usbutils \
  wget \
  wireguard-tools \
  zram-generator-defaults

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf config-manager setopt tailscale-stable.enabled=0
dnf -y install --enablerepo='tailscale-stable' tailscale

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
  vim-minimal \
  wcurl \
  xkeyboard-config

rm -rf /usr/share/doc

echo "::endgroup::"

