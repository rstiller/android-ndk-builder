FROM android-ndk-builder-baseimage

ENV SYSROOT=$NDK/platforms/android-#SDK_VERSION#/arch-#ARCH#

RUN $NDK/build/tools/make-standalone-toolchain.sh --arch=#ARCH# --platform=android-#SDK_VERSION# --toolchain=#TOOLCHAIN#-4.9 --install-dir=/my-toolchain
ENV PATH=/my-toolchain/bin:$PATH
ENV CC=#TOOLCHAIN#-gcc
ENV CXX=#TOOLCHAIN#-g++

RUN echo "yes" | \
    $SDK/tools/android update sdk -u -a -t \
    $(echo $($SDK/tools/android list sdk --all | \
        grep -e "Google APIs, Android API #SDK_VERSION#" -e"SDK Platform Android .*, API #SDK_VERSION#" | \
        awk '/-/{gsub(/-/, ",", $1); print $1}' -) | rev | cut -c 2- | rev | sed 's/ //g')

ENV SDK_PLATFORM=$SDK/platforms/android-#SDK_VERSION#/
