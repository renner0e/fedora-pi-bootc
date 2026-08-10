#!/bin/bash

set -ouex pipefail

# https://github.com/ublue-os/aurora/issues/2568
TMP_OS_RELEASE=$(mktemp --tmpdir 'os-release-XXXXXXXXXX')
cp /usr/lib/os-release "${TMP_OS_RELEASE}"
sed -Ei -e '/^((OSTREE_)?(IMAGE_)?VERSION|PRETTY_NAME|BUILD_ID)=/d' /usr/lib/os-release

DRACUT_NO_XATTR=1 /usr/bin/dracut \
  --verbose \
  --force \
  "$(find /usr/lib/modules -maxdepth 1 -type d | grep -v -E "*.img" | tail -n 1)/initramfs.img"

cp "${TMP_OS_RELEASE}" /usr/lib/os-release
rm "${TMP_OS_RELEASE}"
