#!/bin/bash

if [ "$(uname -m)" = "aarch64" ]; then
  dnf install -y bcm2711-firmware uboot-images-armv8
  cp -P /usr/share/uboot/rpi_arm64/u-boot.bin /boot/efi/rpi-u-boot.bin
  mkdir -p /usr/lib/bootc-raspi-firmwares && cp -a /boot/efi/. /usr/lib/bootc-raspi-firmwares/
  dnf remove -y bcm2711-firmware uboot-images-armv8
  mkdir /usr/bin/bootupctl-orig
  mv /usr/bin/bootupctl /usr/bin/bootupctl-orig/
  printf '%s\n' \
  '#!/usr/bin/bash' \
  'set -euo pipefail' \
  '' \
  '# Restore Raspberry Pi firmware and bootloader files' \
  'if [ -d /usr/lib/bootc-raspi-firmwares ]; then' \
  '  cp -a /usr/lib/bootc-raspi-firmwares/. /boot/efi/' \
  'fi' \
  '' \
  '# Chain to the original bootupctl' \
  'exec /usr/bin/bootupctl-orig/bootupctl "$@"' \
      > /usr/bin/bootupctl
fi
