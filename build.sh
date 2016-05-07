#!/bin/bash

cd buildroot-2016.02/

echo "Compiling buildroot..."

make

if [ "$?" -ne 0 ]; then
  echo "Compiling buildroot failed." >&2
  cd ../
  exit 1
fi

cd ../

echo "======================="
echo "Compiling buildroot succeeded!"
echo ""

echo "Attempting to add the fread init file to buildroot initrd..."

set -e
cp output/images/rootfs.cpio /tmp/
mkdir /tmp/initrd
export PREVDIR=$PWD
cd /tmp/initrd/
cpio -idv < ../rootfs.cpio
rm ../rootfs.cpio
rm init
cp ${PREVDIR}/init ./
chmod 755 init
find . -print -depth | cpio -ov > ${PREVDIR}/initrd.cpio
cd $PREVDIR
rm -rf /tmp/initrd
set +e

echo "Success!"
echo "Your initrd is now compiled and ready at:"
echo "  ${PREVDOR}/initrd.cpio"


