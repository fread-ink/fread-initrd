#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi


BASEDIR=$PWD
BUILDROOT_DIR="${BASEDIR}/buildroot-2016.02"

echo "Creating the .cpio initrd file..."

set -e

rm -rf initrd.cpio
rm -rf output
mkdir output

cd output
cpio -i < ${BUILDROOT_DIR}/output/images/rootfs.cpio
rm -rf dev
../makenodes.sh
cp ../init ./sbin/
find . | cpio --quiet -o -H newc > ../initrd.cpio 

set +e

echo "======================="
echo "Success!"
echo "Your initrd is now compiled and ready at:"
echo "  ${BASEDIR}/initrd.cpio"
