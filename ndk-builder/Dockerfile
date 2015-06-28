FROM ubuntu

RUN apt-get -qq update && apt-get install -y --force-yes --no-install-recommends wget git make
RUN wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && chmod a+x /android-ndk-r10e-linux-x86_64.bin && /android-ndk-r10e-linux-x86_64.bin && rm /android-ndk-r10e-linux-x86_64.bin

ENV NDK=/android-ndk-r10e
ENV ANDROID_NDK=/android-ndk-r10e
ENV PATH=$PATH:$NDK

RUN make $NDK/build/core/build-local.mk
