#!/bin/sh

ARCH=arm
SDK_VERSION=17

if [ "$1" != "" ]; then
ARCH="$1"
fi

if [ "$2" != "" ]; then
SDK_VERSION="$2"
fi

./generate.sh $ARCH $SDK_VERSION

docker build --rm --force-rm=true --tag="android-ndk-builder-baseimage" -f Dockerfile .

docker build --rm --force-rm=true --tag="android-ndk-builder:$ARCH-android-$SDK_VERSION" -f Dockerfile-$ARCH-android-$SDK_VERSION .
