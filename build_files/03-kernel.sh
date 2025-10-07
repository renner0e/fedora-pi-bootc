#!/bin/bash

set -ouex pipefail

echo "::group:: Installing Stable CoreOS Kernel"

if [[ -z "${KERNEL_PIN:-}" ]]; then
    # installs coreos kernel
    KERNEL=$(skopeo inspect --retry-times 3 docker://ghcr.io/ublue-os/akmods:coreos-stable-"$(rpm -E %fedora)" | jq -r '.Labels["ostree.linux"]')
else
    # Install the pinned kernel if KERNEL_PIN is specified
    KERNEL=$(skopeo inspect --retry-times 3 docker://ghcr.io/ublue-os/akmods:coreos-stable-"$(rpm -E %fedora)"-${KERNEL_PIN} | jq -r '.Labels["ostree.linux"]')
fi

skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods:coreos-stable-"$(rpm -E %fedora)"-${KERNEL} dir:/tmp/akmods
AKMODS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods/manifest.json | cut -d : -f 2)
tar -xvzf /tmp/akmods/"$AKMODS_TARGZ" -C /tmp/
mv /tmp/rpms/* /tmp/akmods/

dnf5 -y install /tmp/kernel-rpms/kernel-{core,modules,modules-core,modules-extra}-"${KERNEL}".rpm
# CoreOS doesn't do kernel-tools, removes leftovers from newer kernel
dnf5 -y remove kernel-tools{,-libs}


# Prevent kernel stuff from upgrading again
dnf5 versionlock add kernel{,-core,-modules,-modules-core,-modules-extra,-tools,-tools-lib,-headers,-devel,-devel-matched}


# Turns out we need an initramfs if we wan't to boot
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
chmod 0600 "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
echo "::endgroup::"

