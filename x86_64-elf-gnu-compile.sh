#!/usr/bin/env sh

if [ $# -ne 2 ]; then
  echo "Two arguments required: the bintutils path, the GCC version"
  exit 1
fi

GNU_BINUTILS_DIR=$1
GCC_VERSION=$2

SYSROOT=$(dirname $0)/sysroot

mkdir -p out

VERBOSE= # -v # add "-v" to inspect verbose output

# --gcc-toolchain=$GNU_BINUTILS_DIR seems to be useless. Instead, I need
# to use -B$GNU_BINUTILS_DIR to tell Clang to use binutils therein instead
# of using the default ones.
CROSS_OPTIONS_BASE="""
    --target=x86_64-linux-elf \
    --sysroot=$SYSROOT \
    -isysroot=$SYSROOT \
    -isystem $SYSROOT/usr/include \
    -L$SYSROOT/usr/lib/gcc/x86_64-linux-gnu/$GCC_VERSION \
    -B$GNU_BINUTILS_DIR \
"""
CROSS_OPTIONS_CXX="""
    -isystem $SYSROOT/usr/include/c++/$GCC_VERSION \
    -isystem $SYSROOT/usr/include/x86_64-linux-gnu/c++/$GCC_VERSION \
"""

clang $CROSS_OPTIONS_BASE \
    -o out/hello_c \
    hello.c $VERBOSE

clang++ $CROSS_OPTIONS_BASE $CROSS_OPTIONS_CXX \
    -o out/hello_cc \
    hello.cc $VERBOSE
