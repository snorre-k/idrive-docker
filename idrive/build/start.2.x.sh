#!/usr/bin/env bash

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
perl /etc/idrivecron.pl 1>/dev/null 2>/dev/null &
pid="$!"

# Persist till Signal
while true
do
  tail -f /dev/null & wait $!
done

