# Custom image based on Fedora Bootc for Raspberry Pi 4

Built upon the work of https://github.com/ondrejbudai/fedora-bootc-raspi
# How to Use


## Cross build an arm image from x86 (slow af):
```bash
sudo podman build . --arch arm64 -t localhost/fedora-pi-bootc:latest
```

Edit `config.toml` to your liking to setup ssh key, password and corresponding user


## Create an arm disk image from an x86 machine (also slow af):
```bash
mkdir output
sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
   --security-opt label=type:unconfined_t \
   -v $(pwd)/output:/output \
   -v $(pwd)/config.toml:/config.toml \
   -v /var/lib/containers/storage:/var/lib/containers/storage \
   quay.io/centos-bootc/bootc-image-builder:latest \
   --type raw \
   --local \
   --target-arch arm64 \
   --rootfs ext4 \
   localhost/fedora-pi-bootc:latest
```

## arm-image-installer can only do xz archives
```bash
pv output/image/disk.raw | xz -9 -T0 > output/image/disk.raw.xz
```

## Actually flash the image to the sdcard
```bash
sudo arm-image-installer \
    --target=rpi4 \
    --media=/dev/mysdcard \
    --image output/raw/disk.raw.xz \
    --resizefs
```
