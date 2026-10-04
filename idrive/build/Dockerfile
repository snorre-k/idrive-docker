FROM ubuntu:26.04

# URL of iDrive script package with fallback URL
ARG IDRIVE_URL=https://www.idrivedownloads.com/downloads/linux/linux-bin/idriveforlinux.bin
ARG TARGETPLATFORM


## Install packages & iDrive
    # use nearest archive mirrors
RUN sed -i 's|http://ubuntu.com|mirror://://ubuntu.com|g' /etc/apt/sources.list.d/ubuntu.sources && \
    # Packages & System Upgrade \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
      locales-all \
      tzdata \
      vim \
      nano \
      unzip \
      curl \
      ca-certificates \
      cron \
      iputils-ping \
      iproute2 \
      python3 \
      libpopt0 && \
    # Workaround - tar=1.35+dfsg-4ubuntu0.4 is broken on Ubuntu 26.04 linux/arm64 image \
    if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      DEBIAN_FRONTEND=noninteractive apt-get -y install --allow-downgrades tar=1.35+dfsg-4; \
    fi && \
    # Workaround - iDrive EVS binaries for ARM are compiled for 32bit armhf (which is not available on Ubuntu 26.04) --> /lib/ld-linux.so.3 missing \
    #              Installing basic 32bit linux/armhf C Library & libpopt0 \
    #              Then linking /lib/ld-linux-armhf.so.3 to /lib/ld-linux.so.3 \
    if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      dpkg --add-architecture armhf && \
      apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install libc6:armhf libpopt0:armhf && \
      ln -s /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3; \
    fi && \
    
    # Cleanup \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Get & Setup IDrive - export LD_LIBRARY_PATH for ARM installs
RUN curl -o idriveforlinux.bin ${IDRIVE_URL} && \
    chmod +x idriveforlinux.bin && \
    bash -c 'export TERM=xterm; export LD_LIBRARY_PATH="/opt/IDriveForLinux/bin/Idrivelib/dependencies/python/lib"; echo -ne "A\n" | /idriveforlinux.bin --install; exit 0' && \
    # Cleanup \
    rm idriveforlinux.bin && \
    rm -rf /opt/IDriveForLinux/bin/Idrivelib/dependencies/pkg && \
    # Link idrivecron \
    ln -s /opt/IDriveForLinux/bin/idrive /etc/idrivecron && \
    # Create a backup of /opt/IDriveForLinux/idriveIt in case a bind mount is used or binaries get corrupt or outdated \
    cp -a /opt/IDriveForLinux/idriveIt /opt/IDriveForLinux/idriveIt.orig && \
    # Touch IDrive crontab on volume & link it to /etc \
    touch /opt/IDriveForLinux/idriveIt/idrivecrontab.json && \
    ln -s /opt/IDriveForLinux/idriveIt/idrivecrontab.json /etc/idrivecrontab.json


# Set LD_LIBRARY_PATH (needed for ARM64 image)
ENV LD_LIBRARY_PATH="/opt/IDriveForLinux/bin/Idrivelib/dependencies/python/lib"

# Copy start script
COPY --chmod=755 start.sh /

WORKDIR /opt/IDriveForLinux/bin
VOLUME /opt/IDriveForLinux/idriveIt
ENV LC_ALL=en_US.UTF-8

# Run the start script
CMD ["/start.sh"]

