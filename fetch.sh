#!/bin/bash

BUILDROOT_BASEURL="https://buildroot.org/downloads/"
BUILDROOT_NAME="buildroot-2016.02"
BUILDROOT_FILENAME="${BUILDROOT_NAME}.tar.bz2"
BUILDROOT_URL="${BUILDROOT_BASEURL}${BUILDROOT_FILENAME}"
BUILDROOT_CONFIG="./buildroot.config"
BUSYBOX_CONFIG="./busybox.config"

# check if we're in a subdir of /vagrant
if [[ `pwd` = /vagrant/* ]]; then
  echo "You cannot compile the fread initrd from inside /vagrant" >&2
  echo "since that directory is shared between vm and host" >&2
  echo "in a way that does not allow hardlinks and the" >&2
  echo "buildroot build process requires the use of hardlink." >&2
  exit 1
fi

if [ ! -f "$BUILDROOT_CONFIG" ]; then
  echo "The buildroot config file ${BUILDROOT_CONFIG} is missing!" >&2
  exit 1
fi

if [ ! -f "$BUSYBOX_CONFIG" ]; then
  echo "The busybox config file ${BUSYBOX_CONFIG} is missing!" >&2
  exit 1
fi

if [ -f "$BUILDROOT_FILENAME" ]; then
  echo "Buildroot has already been downloaded."
else

  echo "Downloading buildroot..."

  wget --no-check-certificate $BUILDROOT_URL

  if [ "$?" -ne 0 ]; then
    echo "Downloading buildroot failed" >&2
    exit 1
  fi
fi

echo "Downloading complete!"

if [ -d "$BUILDROOT_NAME" ]; then
  echo "The directory ${BUILDROOT_NAME} already exists." >&2
  echo "If you wish to restart the build process from scratch" >&2
  echo "please move to a different directory or delete the entire" >&2
  echo "${BUILDROOT_NAME} directory but know that this will cause" >&2
  echo "all of the buildroot toolchain and packages" >&2
  echo "to be re-downloaded and re-built" >&2
  exit 1
fi

echo "Extracting buildroot..."

tar xjf $BUILDROOT_FILENAME

if [ "$?" -ne 0 ]; then
  echo "Extracting buildroot failed" >&2
  exit 1
fi

echo "Extraction complete!"

echo "Configuring buildroot..."

cp $BUILDROOT_CONFIG ${BUILDROOT_NAME}/.config

if [ "$?" -ne 0 ]; then
  echo "Configuring buildroot failed" >&2
  exit 1
fi

echo "Buildroot configured!"
echo "to build simply run ./build.sh"

