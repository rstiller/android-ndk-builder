FROM ubuntu

RUN apt-get -qq update && apt-get install -y --force-yes --no-install-recommends wget git make software-properties-common
RUN wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && chmod a+x /android-ndk-r10e-linux-x86_64.bin && /android-ndk-r10e-linux-x86_64.bin && rm /android-ndk-r10e-linux-x86_64.bin

ENV NDK=/android-ndk-r10e
ENV ANDROID_NDK=/android-ndk-r10e
ENV PATH=$PATH:$NDK

RUN make $NDK/build/core/build-local.mk

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java && apt-get -qq update && apt-get install -y --force-yes --no-install-recommends oracle-java8-installer && apt-get install -y --force-yes --no-install-recommends oracle-java8-set-default
RUN apt-get install -y --force-yes --no-install-recommends zip unzip
RUN wget https://services.gradle.org/distributions/gradle-2.4-all.zip && unzip -q gradle-2.4-all.zip && rm gradle-2.4-all.zip && ln -s /gradle-2.4/bin/gradle /usr/bin/gradle

RUN wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz && tar -xzf android-sdk_r24.3.3-linux.tgz && rm /android-sdk_r24.3.3-linux.tgz

ENV SDK=/android-sdk-linux
ENV ANDROID_SDK=/android-sdk-linux
ENV PATH=$PATH:$SDK
