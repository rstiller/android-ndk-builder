#!/bin/bash

if [ `which docker` == "" ]; then
    echo "you need to install docker in order to run the build script"
    exit 1
fi

if [ `which zip` == "" ]; then
    echo "you need to install zip in order to run the build script"
    exit 1
fi

if [ `which git` == "" ]; then
    echo "you need to install git in order to run the build script"
    exit 1
fi

WORKDIR=work
FFMPEG_VERSION=n2.7.1
DISTDIR=dist

mkdir -p $WORKDIR

if [ ! -d "./ffmpeg/" ]; then
    git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
fi

sudo rm -fr $WORKDIR
cp -R ffmpeg $WORKDIR
cp DISTRIBUTION.md $WORKDIR
cd $WORKDIR

git checkout $FFMPEG_VERSION
cp -f ../build_android.sh ../fake-pkg-config .
chmod a+x fake-pkg-config build_android.sh

cd ..

docker run \
    -it \
    --rm \
    -v `pwd`/$WORKDIR:/ffmpeg \
    -w="/ffmpeg" \
    android-ndk-builder:arm-android-17 \
    /ffmpeg/build_android.sh

mkdir -p $DISTDIR
zip -qr9 $DISTDIR/FFmpeg_sources.zip $WORKDIR -x *.so *.o *.git*
cp -R $WORKDIR/DISTRIBUTION.md $WORKDIR/changes.diff $WORKDIR/android $DISTDIR
cp Android.mk $DISTDIR/android/arm/
