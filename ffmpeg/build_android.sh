#!/bin/bash

set -e

sed -i '0,/SLIBNAME_WITH_MAJOR=.*/{s/SLIBNAME_WITH_MAJOR=.*/SLIBNAME_WITH_MAJOR='\''\$\(SLIBPREF\)\$\(FULLNAME\)-\$\(LIBMAJOR\)\$\(SLIBSUF\)'\''/g}' /ffmpeg/configure
sed -i '0,/LIB_INSTALL_EXTRA_CMD=.*/{s/LIB_INSTALL_EXTRA_CMD=.*/LIB_INSTALL_EXTRA_CMD='\''\$\$\(RANLIB\) "\$\(LIBDIR\)\/\$\(LIBNAME\)"'\''/g}' /ffmpeg/configure
sed -i '0,/SLIB_INSTALL_NAME=.*/{s/SLIB_INSTALL_NAME=.*/SLIB_INSTALL_NAME='\''\$\(SLIBNAME_WITH_MAJOR\)'\''/g}' /ffmpeg/configure
sed -i '0,/SLIB_INSTALL_LINKS=.*/{s/SLIB_INSTALL_LINKS=.*/SLIB_INSTALL_LINKS='\''\$\(SLIBNAME\)'\''/g}' /ffmpeg/configure

ARCH="$1"
#TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
TOOLCHAIN=""
case $ARCH in
    "arm" ) TOOLCHAIN="$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-";;
    "x86" ) TOOLCHAIN="$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64/bin/i686-linux-android-";;
    "mips" ) TOOLCHAIN="$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/linux-x86_64/bin/mipsel-linux-android-";;
    "arm64" ) TOOLCHAIN="$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-";;
    "x86_64" ) TOOLCHAIN="$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64/bin/x86_64-linux-android-";;
    "mips64" ) TOOLCHAIN="$NDK/toolchains/mips64el-linux-android-4.9/prebuilt/linux-x86_64/bin/mips64el-linux-android-";;
esac

CPU="$2"
PREFIX=$(pwd)/android/$CPU
EXTRA_CFLAGS="-Os -fpic --static $3"
ADDI_LDFLAGS="--static -lz"

git diff > changes-$1.diff

CONFIGURE_PARAMS="--prefix=$PREFIX \
--pkg-config=/ffmpeg/fake-pkg-config \
--enable-pic \
--enable-zlib \
--disable-debug \
--disable-shared \
--enable-static \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-avdevice \
--disable-doc \
--disable-symver \
--cross-prefix=$TOOLCHAIN \
--target-os=linux \
--arch=$ARCH \
--enable-cross-compile \
--sysroot=$SYSROOT \
$4 \
--extra-ldflags=\$ADDI_LDFLAGS \
--extra-cflags=\$EXTRA_CFLAGS"

echo "CONFIGURE_PARAMS for $ARCH: $CONFIGURE_PARAMS" >> __CONFIGURE__.txt
echo "" >> __CONFIGURE__.txt
echo "EXTRA_CFLAGS for $ARCH: $EXTRA_CFLAGS" >> __CONFIGURE__.txt
echo "" >> __CONFIGURE__.txt

./configure $CONFIGURE_PARAMS
make -j 4
make install
