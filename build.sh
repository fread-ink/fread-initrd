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



