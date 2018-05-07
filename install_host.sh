#!/bin/bash
# Copyright 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ "$(uname -s)" = "Darwin" ]; then
  if [ "$(whoami)" = "root" ]; then
    CHROME_TARGET_DIR="/Library/Google/Chrome/NativeMessagingHosts"
    CHROMIUM_TARGET_DIR="/Library/Application Support/Chromium/NativeMessagingHosts/"
  else
    CHROME_TARGET_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
    CHROMIUM_TARGET_DIR="$HOME/Library/Application Support/Chromium/NativeMessagingHosts/"
  fi
else
  if [ "$(whoami)" = "root" ]; then
    CHROME_TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
    CHROMIUM_TARGET_DIR="/etc/chromium/native-messaging-hosts"
  else
    CHROME_TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
    CHROMIUM_TARGET_DIR="$HOME/.config/chromium/NativeMessagingHosts"
  fi
fi

HOST_NAME=com.guld.ledger

# Create directory to store native messaging host.
mkdir -p "$CHROME_TARGET_DIR"
mkdir -p "$CHROMIUM_TARGET_DIR"

# Copy native messaging host manifest.
cp "$DIR/$HOST_NAME.json" "$CHROME_TARGET_DIR"
cp "$DIR/$HOST_NAME.json" "$CHROMIUM_TARGET_DIR"

# Update host path in the manifest.
HOST_PATH="$DIR/ledger-native.py"
echo $HOST_PATH
ESCAPED_HOST_PATH=${HOST_PATH////\\/}
sed -i -e "s/HOST_PATH/$ESCAPED_HOST_PATH/" "$CHROME_TARGET_DIR/$HOST_NAME.json"
sed -i -e "s/HOST_PATH/$ESCAPED_HOST_PATH/" "$CHROMIUM_TARGET_DIR/$HOST_NAME.json"

# Set permissions for the manifest so that all users can read it.
chmod o+r "$CHROME_TARGET_DIR/$HOST_NAME.json"
chmod o+r "$CHROMIUM_TARGET_DIR/$HOST_NAME.json"

echo "Native messaging host $HOST_NAME has been installed."
