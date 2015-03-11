#!/bin/bash

if [ -z $KERNEL_BASEURL ]; then
  url=https://www.kernel.org/pub/linux/kernel/
else
  url=$KERNEL_BASEURL
fi

if [ -z $IMAGE ]; then
  image=image.iso
else
  image=$IMAGE
fi

if [ -z $KERNEL_VERSION ]; then
  version=3.18.9
else
  version=$KERNEL_VERSION
fi

if [ -z $ROOTFS_CPIO ]; then
  fdinitrd=rootfs.cpio.gz
else
  fdinitrd=$ROOTFS_CPIO
fi

if [ ! -d linux-$version ]; then
  curl -q -L -O $url/v${version%%.*}.x/linux-${version}.tar.xz
  tar -xvf linux-${version}.tar.xz
  cd linux-$version
  for i in ../patches/*.patch; do
    patch -p1 < $i
  done
  cp ../config-$version .config
else
  cd linux-$version
fi

make bzImage
echo "fdinitrd=$fdinitrd"
make isoimage FDARGS="console=ttyS0 quiet" FDINITRD="$fdinitrd"
cp arch/x86/boot/image.iso $image
