.. _CRUX: https://crux.nu/
.. _Kernel: https://www.kernel.org/
.. _Busybox: http://www.busybox.net/
.. _Dropbear: https://matt.ucc.asn.au/dropbear/dropbear.html
.. _Docker: https://www.docker.com/
.. _finit: http://troglobit.com/finit.html
.. _qemu: http://www.qemu.org/


pOS - Pico Operating System
===========================

pOS (*Pico Operating System*) for want of a better name
is a small, minimal Linux based Operating System with the
following high level goals:

* Minimal with just enough to boot a system, login and install new software.
* `CRUX`_ style ports system for package building
* Compatible with `CRUX`_s ``Pkgfile`` format.
* Binary based package manager.

The core system is comprised of the following components:

* `Kernel`_
* `Busybox`_
* `Dropbear`_ (*TBD*)
* `Docker`_ (*TBD*)
* `finit`_ (*TBD*)


Building
--------

::
    
    git clone https://github.com/therealprologic/pos.git
    cd pos
    ./build.sh


Testing
-------

For the moment you can test the resulting ``image.iso`` built by using `qemu`_::
    
    qemu-system-x86_64 -cdrom image.iso -net bridge,br=br0 -net nic


.. note:: Right now a couple of assumptions are made.
          CRUX is used as the host system for building.
          You have a fully working `qemu`_ setup and preconfigured ``br0`` bridge to your LAN.
