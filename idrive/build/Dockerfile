FROM ubuntu:24.04

# Install packages
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
      locales-all \
      tzdata \
      vim \
      unzip \
      curl \
      cron \
      iputils-ping \
      iproute2 \
      python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get & Setup IDrive
RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/linux-bin/idriveforlinux.bin && \
    chmod +x idriveforlinux.bin && \
    bash -c 'export TERM=xterm; echo -ne "A\n" | /idriveforlinux.bin --install; exit 0' && \
    rm /idriveforlinux.bin && \
    ln -s /opt/IDriveForLinux/bin/idrive /etc/idrivecron

# Touch IDrive crontab on volume & link it to /etc
RUN touch /opt/IDriveForLinux/idriveIt/idrivecrontab.json && \
    ln -s /opt/IDriveForLinux/idriveIt/idrivecrontab.json /etc/idrivecrontab.json

# Create a backup of /opt/IDriveForLinux/idriveIt in case a bind mount is used or binaries get corrupt or outdated
RUN cp -a /opt/IDriveForLinux/idriveIt /opt/IDriveForLinux/idriveIt.orig

# Set LD_LIBRARY_PATH (needed for ARM64 image)
ENV LD_LIBRARY_PATH="/opt/IDriveForLinux/bin/Idrivelib/dependencies/python/lib"

# Copy start script
COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /opt/IDriveForLinux/bin
VOLUME /opt/IDriveForLinux/idriveIt
ENV LC_ALL=en_US.UTF-8

# Run the start script
CMD ["/start.sh"]

