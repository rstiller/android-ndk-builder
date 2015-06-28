#!/bin/bash

ARCH=arm
SDK_VERSION=17

if [ "$1" != "" ]; then
ARCH="$1"
fi

if [ "$2" != "" ]; then
SDK_VERSION="$2"
fi

FILE="Dockerfile-$ARCH-android-$SDK_VERSION"

cp Dockerfile.tpl $FILE
sed -i "s/#ARCH#/${ARCH}/g" $FILE
sed -i "s/#SDK_VERSION#/${SDK_VERSION}/g" $FILE
