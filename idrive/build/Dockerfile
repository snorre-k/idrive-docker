FROM ubuntu:22.04

# Install packages
RUN apt-get update && apt-get -y install \
      vim \
      unzip \
      curl \
      python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get IDrive
RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/linux-bin/idriveforlinux.bin && \
    chmod +x idriveforlinux.bin

# Setup IDrive
RUN bash -c 'export TERM=xterm; echo -ne "\nn\n" | /IDriveForLinux/scripts/account_setting.pl; exit 0' && \
    ln -s /opt/IDriveForLinux/bin/idrive /etc/idrivecron

# Touch IDrive crontab on volume & link it to /etc
RUN touch /opt/IDriveForLinux/idriveIt/idrivecrontab.json && \
    ln -s /opt/IDriveForLinux/idriveIt/idrivecrontab.json /etc/idrivecrontab.json

# Copy start script
COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /opt/IDriveForLinux/bin
VOLUME /opt/IDriveForLinux/idriveIt

# Run the start script
CMD ["/start.sh"]

