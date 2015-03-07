#!/bin/bash

KVER=3.18.8


if [ ! -f linux-$KVER.tar.xz ]; then
  curl -q -L -O https://www.kernel.org/pub/linux/kernel/v3.x/linux-${KVER}.tar.xz
fi

if [ ! -d linux-$KVER ]; then
  tar -xvf linux-${KVER}.tar.xz
  cd linux-$KVER
  for i in ../patches/*.patch; do
    patch -p1 < $i
  done
else
  cd linux-$KVER
fi

if [ ! -f .config ]; then
  make defconfig
fi

make bzImage
make isoimage FDARGS="console=ttyS0 quiet" FDINITRD=$ROOTFS
cp arch/x86/boot/image.iso $OUTPUT
