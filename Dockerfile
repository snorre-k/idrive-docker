FROM ubuntu:22.04

# Install packages
RUN apt-get update && apt-get -y install \
      vim \
      unzip \
      curl \
      libfile-spec-native-perl \
      build-essential \
      sqlite3 \
      perl-doc \
      libdbi-perl \
      libdbd-sqlite3-perl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cpan install common::sense Linux::Inotify2

# Install IDrive
RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip && \
    unzip IDriveForLinux.zip && \
    rm IDriveForLinux.zip && \
    chmod +x /IDriveForLinux/scripts/*.pl && \
    ln -s /IDriveForLinux/scripts/cron.pl /etc/idrivecron.pl

# Get IDrive initial binaries
RUN bash -c 'export TERM=xterm; echo -ne "\nn\n" | /IDriveForLinux/scripts/account_setting.pl; exit 0'

# Touch IDrive crontab on volume & link it to /etc
RUN touch /IDriveForLinux/idriveIt/idrivecrontab.json && \
    ln -s /IDriveForLinux/idriveIt/idrivecrontab.json /etc/idrivecrontab.json

# Copy start script
COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /IDriveForLinux/scripts
VOLUME /IDriveForLinux/idriveIt

# Run the start script
CMD ["/start.sh"]

