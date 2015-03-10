#!/bin/bash


warn () {
  echo "Warning:" "$@" >&2
}

die () {
  rc=$1
  shift
  echo "ERROR:" "$@" >&2
  exit $rc
}

export TOP=$(pwd)
export PATH="$TOP/tools:$PATH"
export ROOTFS=$TOP/rootfs.cpio.gz
export OUTPUT=$TOP

packages=(busybox dropbear finit fs rc)

echo "Building packages ..."
for package in ${packages[@]}; do
  (
    echo " Building $package ..."
    cd packages/$package
    fakeroot pkgmk -d &> $TOP/$package.log || die 1 "Building $package failed! See: $package.log"
  ) || die 1 "Error building packages!"
done

echo "Building rootfs ... (root required)"

rm -rf rootfs.tar.xz rootfs.cpio.gz
sudo rm -rf rootfs
mkdir rootfs

for package in ${packages[@]}; do
  sudo tar --numeric-owner -C rootfs -xf packages/$package/$package#*.tar.gz
done

(
  cd rootfs
  find . | sudo cpio -H newc -o | gzip
) > rootfs.cpio.gz

sudo tar --numeric-owner \
    --exclude=./init \
    --exclude=./etc/mtab \
    --exclude=./root/.bash_history \
    -P -cJf rootfs.tar.xz \
    -C rootfs ./

echo "Building kernel and image ..."
(
  cd kernel
  ./build.sh &> $TOP/kernel.log
)

echo "All done!"
