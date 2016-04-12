#!/bin/bash

ARCH=arm
SDK_VERSION=17

if [ "$1" != "" ]; then
ARCH="$1"
fi

if [ "$2" != "" ]; then
SDK_VERSION="$2"
fi

# http://developer.android.com/ndk/guides/standalone_toolchain.html

TOOLCHAIN=""
case $ARCH in
    "arm" ) TOOLCHAIN="arm-linux-androideabi";;
    "x86" ) TOOLCHAIN="x86";;
    "mips" ) TOOLCHAIN="mipsel-linux-android";;
    "arm64" ) TOOLCHAIN="aarch64-linux-android";;
    "x86_64" ) TOOLCHAIN="x86_64";;
    "mips64" ) TOOLCHAIN="mips64el-linux-android";;
esac

FILE="Dockerfile-$ARCH-android-$SDK_VERSION"

cp Dockerfile.tpl $FILE
sed -i "s/#ARCH#/${ARCH}/g" $FILE
sed -i "s/#TOOLCHAIN#/${TOOLCHAIN}/g" $FILE
sed -i "s/#SDK_VERSION#/${SDK_VERSION}/g" $FILE
