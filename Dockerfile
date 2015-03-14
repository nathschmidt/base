FROM crux:3.1

# Update ports
RUN ports -u && \
    prt-get cache

# Install cdrtools and syslinux for mkisofs
RUN prt-get depinst cmake syslinux httpup && \
    httpup sync http://crux.shortcircuit.net.au/#cdrtools cdrtools && \
    cd cdrtools && \
    pkgmk -d -i

# Install git for some package sources
RUN prt-get depinst git

# Kernel version
ENV KERNEL_BASEURL=https://www.kernel.org/pub/linux/kernel/
ENV KERNEL_VERSION=3.18.9

COPY . /work

# Download Kernel sources
WORKDIR /work/kernel
RUN curl -q -L -O ${KERNEL_BASEURL}/v${KERNEL_VERSION%%.*}.x/linux-${KERNEL_VERSION}.tar.xz && \
    tar -xvf linux-${KERNEL_VERSION}.tar.xz

# Download Package sources
WORKDIR /work/packages
RUN pkgmk -do -r

WORKDIR /work
CMD ["./scripts/build.sh"]
