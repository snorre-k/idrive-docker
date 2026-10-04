FROM ubuntu:26.04

# URL of iDrive script package with fallback URL
ARG IDRIVE_URL=https://www.idrivedownloads.com/downloads/linux/linux-bin/idriveforlinux.bin

# use nearest archive mirrors
RUN sed -i 's|http://ubuntu.com|mirror://://ubuntu.com|g' /etc/apt/sources.list.d/ubuntu.sources

# Install packages
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
      locales-all \
      tzdata \
      vim \
      nano \
      unzip \
      curl \
      cron \
      iputils-ping \
      iproute2 \
      python3 \
      libpopt0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get & Setup IDrive - export LD_LIBRARY_PATH for ARM installs
RUN curl -o idriveforlinux.bin ${IDRIVE_URL} && \
    chmod +x idriveforlinux.bin && \
    bash -c 'export TERM=xterm; export LD_LIBRARY_PATH="/opt/IDriveForLinux/bin/Idrivelib/dependencies/python/lib"; echo -ne "A\n" | /idriveforlinux.bin --install; exit 0' && \
    rm idriveforlinux.bin && \
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

