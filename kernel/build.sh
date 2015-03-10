#!/bin/bash

name=linux
version=3.18.9


if [ ! -d $name-$version ]; then
  curl -q -L -O https://www.kernel.org/pub/$name/kernel/v${version%%.*}.x/$name-${version}.tar.xz
  tar -xvf $name-${version}.tar.xz
  cd $name-$version
  for i in ../patches/*.patch; do
    patch -p1 < $i
  done
  cp ../config-$version .config
else
  cd $name-$version
fi

make bzImage
make isoimage FDARGS="console=ttyS0 quiet" FDINITRD=$ROOTFS
cp arch/x86/boot/image.iso $OUTPUT
