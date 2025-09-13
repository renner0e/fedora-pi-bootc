#!/bin/bash

set -ouex pipefail

# append my cosign key to the ublue config file
jq '.transports.docker["ghcr.io/renner0e"] = [{"type":"sigstoreSigned","keyPaths":["/etc/pki/containers/renner.pub","/etc/pki/containers/renner.pub"],"signedIdentity":{"type":"matchRepository"}}]' /usr/etc/containers/policy.json > /etc/containers/policy.json

ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/nvim /usr/bin/vi

# Enable systemd services
# activate podman timer for root user
# activate podman auto update for all normal users
systemctl enable podman-auto-update.timer
systemctl --global enable podman-auto-update.timer

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=7d\nPersistent=true|' /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
