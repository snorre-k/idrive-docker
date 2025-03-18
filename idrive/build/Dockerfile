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

# Copy start script
COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /opt/IDriveForLinux/bin
VOLUME /opt/IDriveForLinux/idriveIt
ENV LC_ALL=en_US.UTF-8

# Run the start script
CMD ["/start.sh"]

