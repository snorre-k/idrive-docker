#!/usr/bin/env bash

# Set Timezone from $TZ environment variable
if [ "$TZ" ]; then
  # Check if timezone exists in /usr/share/zoneinfo folder
  if [ -f "/usr/share/zoneinfo/$TZ" ]; then
    # create /etc/localtime link
    if ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; then
      dpkg-reconfigure -f noninteractive tzdata
    fi
  fi
fi

# Copy binaries in /opt/IDriveForLinux/idriveIt.orig to original location
cp -a /opt/IDriveForLinux/idriveIt.orig/idevsutil* /opt/IDriveForLinux/idriveIt/

# Entrypoint for idrive
echo "iDrive start.."

# Handler
exit_handler() {
  echo "iDrive stop..."
  exit 0
}

# Exit trap
trap 'kill ${!}; exit_handler' EXIT

# Start IDrive CRON in background
/etc/idrivecron --cron 1>/dev/null 2>/dev/null &
pid="$!"

# Persist till Signal
while true
do
  tail -f /dev/null & wait $!
done

