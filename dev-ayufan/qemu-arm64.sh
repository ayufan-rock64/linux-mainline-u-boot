#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <image.img> [qemu-args...]"
fi

ROOT=$(dirname "$(readlink -f "$0")")
IMAGE="$1"
shift

BRIDGE=${BRIDGE:-br0}
BIOS=${BIOS:-$ROOT/../tmp/u-boot-qemu-arm64/u-boot.bin}

if [[ ! -e "$BIOS" ]]; then
  echo "Missing $BIOS. Run:"
  echo "./dev-shell ./dev-make u-boot-bin BOARD_TARGET=qemu-arm64"
  exit 1
fi

if ip link show br0 &>/dev/null; then
  echo "Attach tap to br0"
  NETDEV="tap,script=$ROOT/qemu-ifup"
  SUDO="sudo -E"
else
  echo "No br0, using netdev=user"
  NETDEV=user
  SUDO=""
fi

MACADDR=$(echo "$IMAGE"|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')

exec $SUDO qemu-system-aarch64 \
  -m 2048 \
  -machine virt \
  -cpu cortex-a53 \
  -smp 4 \
  -bios "$BIOS" \
  -device "usb-ehci" \
  -device "virtio-keyboard-pci" \
  -device "virtio-tablet-pci" \
  -device "virtio-balloon-pci" \
  -device "virtio-net-device,netdev=net0,mac=$MACADDR" \
  -device "virtio-gpu-pci,xres=1920,yres=1080" \
  -device "virtio-blk-device,drive=hd0" \
  -netdev "$NETDEV,id=net0" \
  -serial "mon:stdio" \
  -drive "if=none,file=$IMAGE,id=hd0" \
  "$@"
