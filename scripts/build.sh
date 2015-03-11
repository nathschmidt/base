#!/bin/bash

die () {
  rc=$1
  shift
  echo "ERROR:" "$@" >&2
  exit $rc
}

export TOP=$(pwd)
export LOGS=$TOP/logs
export KERNEL=$TOP/kernel
export ROOTFS=$TOP/rootfs
export IMAGE=$TOP/image.iso
export PACKAGES=$TOP/packages
export ROOTFS_CPIO=$TOP/rootfs.cpio.gz
export ROOTFS_TARBALL=$TOP/rootfs.tar.xz

export PATH="$TOP/tools:$PATH"

packages=(busybox dropbear finit fs rc)

echo "Building packages ..."
for package in ${packages[@]}; do
  (
    echo " Building $package ..."
    cd $PACKAGES/$package
    pkgmk -d &> $LOGS/$package.log || die 1 "Building $package failed! See: $LOGS/$package.log"
  ) || die 1 "Error building packages!"
done


echo "Building rootfs ... "

rm -rf $ROOTFS && mkdir $ROOTFS
rm -rf $ROOTFS_CPIO $ROOTFS_IMAGE

for package in ${packages[@]}; do
  tar --numeric-owner -C $ROOTFS -xf $PACKAGES/$package/$package#*.tar.gz
done

(
  cd $ROOTFS
  find . | cpio -H newc -o | gzip
) > $ROOTFS_CPIO

sudo tar --numeric-owner \
    --exclude=./init \
    --exclude=./.empty \
    --exclude=./etc/mtab \
    --exclude=./root/.bash_history \
    -P -cJf $ROOTFS_TARBALL \
    -C $ROOTFS ./

echo "Building kernel and image ..."
(
  cd $KERNEL
  ./build.sh &> $LOGS/kernel.log
)

echo "All done!"
