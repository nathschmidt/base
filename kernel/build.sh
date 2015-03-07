#!/bin/bash

name=linux
version=3.18.8


if [ ! -f $name-$version ]; then
  curl -q -L -O https://www.kernel.org/pub/$name/kernel/v${version%%.*}.x/$name-${version}.tar.xz
fi

if [ ! -d $name-$version ]; then
  tar -xvf $name-${version}.tar.xz
  cd $name-$version
  for i in ../patches/*.patch; do
    patch -p1 < $i
  done
else
  cd $name-$version
fi

if [ ! -f .config ]; then
  cp ../config-$version .config
fi

make bzImage
make isoimage FDARGS="console=ttyS0 quiet" FDINITRD=$ROOTFS
cp arch/x86/boot/image.iso $OUTPUT
