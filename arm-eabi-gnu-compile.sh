#!/usr/bin/env sh

if [ $# -ne 2 ]; then
  echo "Two arguments required: the bintutils path, the GCC version"
  exit 1
fi

GNU_BINUTILS_DIR=$1
GCC_VERSION=$2

SYSROOT=$(dirname $0)/sysroot

mkdir -p out

clang++ \
    --target=x86_64-linux-elf \
    --sysroot=$SYSROOT \
    -isysroot=$SYSROOT \
    -isystem $SYSROOT/usr/include/c++/$GCC_VERSION \
    -isystem $SYSROOT/usr/include/arm-linux-gnueabihf/c++/$GCC_VERSION \
    -L$SYSROOT/usr/lib/gcc/arm-linux-gnueabihf/$GCC_VERSION \
    -B$SYSROOT/usr/lib/gcc/arm-linux-gnueabihf/$GCC_VERSION \
    -B$GNU_BINUTILS_DIR \
    --gcc-toolchain=$GNU_BINUTILS_DIR \
    -o out/hello \
    hello.cc # -v # add "-v" to inspect verbose output
