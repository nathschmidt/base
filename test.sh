#!/bin/bash

qemu-system-x86_64 -cdrom image.iso -net bridge,br=br0 -net nic
