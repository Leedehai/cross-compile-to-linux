#!/usr/bin/env sh
# This script rsyncs necessary headers and libraries from x86_64 Linux
# to the local machine in order to prepare cross-compiling to Linux.

# This article describes how to cross-compile from
# macOS to Rasberry Pi (ARM architecture):
# https://medium.com/@haraldfernengel/ \
# cross-compiling-c-c-from-macos-to-raspberry-pi-in-2-easy-steps-23f391a8c63

if [ $# -ne 1 ]; then
  echo "One argument expected: remote shell login username@1.2.3.4"
  exit 1
fi

LINUX_REMOTE_SHELL=$1

DOWNLOAD_TO=$(dirname "$0")/sysroot

rm -rf $DOWNLOAD_TO
mkdir -p $DOWNLOAD_TO

# -r: recurse into directories
# -z: compress file data during transfer
# -L: if symlinks are encountered, copy the targets they point to
# -R: full paths are sent to the sever rather than just the last parts
# --safe-links: ignore symlinks which point outside the copied tree and
#     ignore all absolute symlinks
RSYNC_COMMAND="rsync -rzLR --safe-links"

HAS_ERROR=0
rsync_get() {
  echo "fetching $1"
  $RSYNC_COMMAND $LINUX_REMOTE_SHELL:$1 $DOWNLOAD_TO
  if [ $? -eq 0 ]; then
    echo "ok."
  else
    HAS_ERROR=1
    echo "error."
  fi
}

# macOS built-in rsync is lame: rsync doesn't accept multiple remote
# source paths (version 2.6.9)
rsync_get "/usr/lib/x86_64-linux-gnu"
rsync_get "/usr/lib/gcc/x86_64-linux-gnu"
rsync_get "/usr/include"
rsync_get "/lib/x86_64-linux-gnu"

if [ $HAS_ERROR -eq 0 ]; then
  echo "Downloaded to $DOWNLOAD_TO"
  exit 0
else
  echo "Error."
  exit 1
fi
