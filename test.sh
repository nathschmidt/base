#!/bin/bash

gui=0

while getopts g opt; do
  case $opt in
  g)
      gui=1
      ;;
  esac
done

shift $((OPTIND - 1))

echo "Booting..."
echo

if (( gui == 1 )); then
  qemu-system-x86_64 -cdrom image.iso -net bridge,br=br0 -net nic
else
  qemu-system-x86_64 -nographic -cdrom image.iso -net bridge,br=br0 -net nic
fi
