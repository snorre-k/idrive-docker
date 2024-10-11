#!/bin/bash

VERSION_URL="https://www.idrivedownloads.com/downloads/linux/download-for-linux/linux-backup.script.js"
VERSION=$(curl -s $VERSION_URL | grep 'var linuxVersion =' | sed 's/.*var linuxVersion = "\([0-9.]*\)".*/\1/')

echo "iDrive latest version: $VERSION"
echo "idrive_version=$VERSION" >> $GITHUB_OUTPUT

