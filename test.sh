#!/bin/bash

echo "Booting..."
echo

qemu-system-x86_64 -nographic -cdrom image.iso -net bridge,br=br0 -net nic
