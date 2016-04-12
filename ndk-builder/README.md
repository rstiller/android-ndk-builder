#ndk-builder

This docker image encapsulates the android ndk.
When using this builder you agree to the terms and conditions found at the ndk download page
https://developer.android.com/ndk/downloads/index.html#download

This image sets up the ndk environment and set the environment variables accordingly.

# usage

    ./build.sh arm 17

Where 'arm' is the architechture and '17' is the Android SDK Level.

For an example usage take a look at this repository's other folders.

In most cases you use the builder by running the container with the sources mounted
in a folder and a build-script compiling the sources.
