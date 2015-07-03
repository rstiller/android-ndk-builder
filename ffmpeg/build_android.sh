#!/bin/bash

set -e

sed -i '0,/SLIBNAME_WITH_MAJOR=.*/{s/SLIBNAME_WITH_MAJOR=.*/SLIBNAME_WITH_MAJOR='\''\$\(SLIBPREF\)\$\(FULLNAME\)-\$\(LIBMAJOR\)\$\(SLIBSUF\)'\''/g}' /ffmpeg/configure
sed -i '0,/LIB_INSTALL_EXTRA_CMD=.*/{s/LIB_INSTALL_EXTRA_CMD=.*/LIB_INSTALL_EXTRA_CMD='\''\$\$\(RANLIB\) "\$\(LIBDIR\)\/\$\(LIBNAME\)"'\''/g}' /ffmpeg/configure
sed -i '0,/SLIB_INSTALL_NAME=.*/{s/SLIB_INSTALL_NAME=.*/SLIB_INSTALL_NAME='\''\$\(SLIBNAME_WITH_MAJOR\)'\''/g}' /ffmpeg/configure
sed -i '0,/SLIB_INSTALL_LINKS=.*/{s/SLIB_INSTALL_LINKS=.*/SLIB_INSTALL_LINKS='\''\$\(SLIBNAME\)'\''/g}' /ffmpeg/configure

TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
CPU=arm
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-Os -fpic -marm -mfpu=neon --static"
ADDI_LDFLAGS="--static"

git diff > changes.diff

CONFIGURE_PARAMS="--prefix=$PREFIX \
--pkg-config=/ffmpeg/fake-pkg-config \
--enable-pic \
--disable-debug \
--disable-shared \
--enable-static
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-avdevice \
--disable-doc \
--disable-symver \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--target-os=linux \
--arch=arm \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-ldflags=\$ADDI_LDFLAGS \
--extra-cflags=\$EXTRA_CFLAGS"

echo "$CONFIGURE_PARAMS" >> DISTRIBUTION.md
echo "" >> DISTRIBUTION.md
echo "EXTRA_CFLAGS: $EXTRA_CFLAGS" >> DISTRIBUTION.md

#make clean
./configure $CONFIGURE_PARAMS
make
make install
