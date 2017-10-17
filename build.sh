#!/bin/bash

BUILDROOT_DIR="buildroot-2016.02"

cd $BUILDROOT_DIR

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
PREVDIR=$PWD
cd ${BUILDROOT_DIR}/output/target/
rm -f init
rm -f THIS_IS_NOT_YOUR_ROOT_FILESYSTEM
cp ${PREVDIR}/init ./
chmod 755 init
rm -f ${PREVDIR}/initrd.cpio
find . | cpio --quiet -o -H newc > ${PREVDIR}/initrd.cpio 
cd $PREVDIR
set +e

echo "Success!"
echo "Your initrd is now compiled and ready at:"
echo "  ${PREVDIR}/initrd.cpio"


