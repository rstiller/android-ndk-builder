FROM android-ndk-builder-baseimage

ENV SYSROOT=$NDK/platforms/android-#SDK_VERSION#/arch-#ARCH#

RUN $NDK/build/tools/make-standalone-toolchain.sh --system=linux-x86_64 --arch=#ARCH# --platform=android-#SDK_VERSION# --toolchain=#ARCH#-linux-androideabi-4.9 --install-dir=/my-toolchain
ENV PATH=/my-toolchain/bin:$PATH
ENV CC=#ARCH#-linux-androideabi-gcc
ENV CXX=#ARCH#-linux-androideabi-g++
