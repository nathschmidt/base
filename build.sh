#!/bin/bash

for pkg in packages/*; do
  (cd $pkg && fakeroot pkgmk -d)
done

rm -rf rootfs rootfs.cpio.gz

mkdir rootfs

for pkg in packages/*/*#*; do
  tar -C rootfs -xvf $pkg
done

(cd rootfs && find . | cpio -H newc -o | gzip) > rootfs.cpio.gz

export ROOTFS=$(pwd)/rootfs.cpio.gz
export OUTPUT=$(pwd)

(cd kernel && ./build.sh)
