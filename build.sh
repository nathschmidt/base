#!/bin/bash

if [ "$UID" != "0" ]; then
  echo "You need to be root to do this."
  exit 1
fi

export PATH="$(pwd)/tools:$PATH"

for pkg in packages/*; do
  (cd $pkg && fakeroot pkgmk -d)
done

# If we didn't manage to make our packages error out
if [ ! -f packages/*/*#* ]
	then
		# @todo: echo to stderr 
		echo "Required packages not created."
		exit 1
fi

rm -rf rootfs rootfs.tar.xz rootfs.cpio.gz

mkdir rootfs

for pkg in packages/*/*#*; do
  tar --numeric-owner -C rootfs -xf $pkg
done

(cd rootfs && find . | cpio -H newc -o | gzip) > rootfs.cpio.gz

tar --numeric-owner \
    --exclude=./init \
    --exclude=./etc/mtab \
    --exclude=./root/.bash_history \
    -P -cJf rootfs.tar.xz \
    -C rootfs ./

export ROOTFS=$(pwd)/rootfs.cpio.gz
export OUTPUT=$(pwd)

(cd kernel && ./build.sh)
