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

mkdir -p $DISTDIR
cp DISTRIBUTION.md $DISTDIR

function setup() {
    rm -fr $WORKDIR
    cp -R ffmpeg $WORKDIR
    cd $WORKDIR

    git checkout $FFMPEG_VERSION
    cp -f ../build_android.sh ../fake-pkg-config .
    chmod a+x fake-pkg-config build_android.sh

    cd ..
}

function build() {
    setup
    docker run -it --rm -v `pwd`/$WORKDIR:/ffmpeg -w="/ffmpeg" android-ndk-builder:$1 /ffmpeg/build_android.sh "$2" "$3" "$4" "$5"
    zip -qr9 $DISTDIR/FFmpeg_sources-$2.zip $WORKDIR -x *.a *.so *.o *.git*
    cp -R $WORKDIR/changes*.diff $WORKDIR/android $DISTDIR
    cp Android.mk $DISTDIR/android/$2/
    cat $WORKDIR/__CONFIGURE__.txt >> $DISTDIR/DISTRIBUTION.md
}

# for each arch
build "arm-android-21"    "arm"    "arm"    "-marm -mfpu=neon"                            ""
build "arm64-android-21"  "arm64"  "arm64"  "-marm64 -mfpu=neon"                          ""
build "x86-android-21"    "x86"    "x86"    "-march=atom -msse3 -ffast-math -mfpmath=sse" "--disable-amd3dnow --disable-amd3dnowext --enable-asm --enable-yasm"
build "x86_64-android-21" "x86_64" "x86_64" "-march=atom -msse3 -ffast-math -mfpmath=sse" "--disable-amd3dnow --disable-amd3dnowext --enable-asm --enable-yasm"
