FROM debian:jessie

RUN set -ex && \
    apt-get update && \
    apt-get install -y eatmydata && \
    eatmydata apt-get --no-install-recommends --yes install \
        ca-certificates \
        apt-transport-https \
        curl \
        unzip \
        automake \
        python \
        build-essential \
        file \
        pkg-config \
        libtool-bin \
        libssl-dev \
        git

WORKDIR /opt/android
ARG BUILD_JOBS=1

# Download & Build CMake
ARG CMAKE_VERSION=3.16.5
ARG CMAKE_VERSION_DOT=v3.16
ARG CMAKE_HASH=5f760b50b8ecc9c0c37135fae5fbf00a2fef617059aa9d61c1bb91653e5a8bfc
RUN set -ex \
    && curl -s -O https://cmake.org/files/${CMAKE_VERSION_DOT}/cmake-${CMAKE_VERSION}.tar.gz \
    && echo "${CMAKE_HASH}  cmake-${CMAKE_VERSION}.tar.gz" | sha256sum -c \
    && tar -xzf cmake-${CMAKE_VERSION}.tar.gz \
    && cd cmake-${CMAKE_VERSION} \
    && ./configure \
    && make -j${BUILD_JOBS} \
    && make install

# Download NDK
# Available revisions: 18b, 19c, 20b, 21d
ARG ANDROID_NDK_REVISION=21d
RUN curl -s -O https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip \
    && unzip android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip \
    && rm -f android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip \
    && ln -s android-ndk-r${ANDROID_NDK_REVISION} ndk

# Toolchain Setup
ARG ARM_BUILD_FOLDER=/opt/android/build/arm
ARG ARM64_BUILD_FOLDER=/opt/android/build/arm64
ARG X86_BUILD_FOLDER=/opt/android/build/x86
ARG X86_64_BUILD_FOLDER=/opt/android/build/x86_64
ARG ANDROID_API=21
ARG TOOLCHAIN_BIN=/opt/android/ndk/toolchains/llvm/prebuilt/linux-x86_64/bin

ARG ARM_TARGET=arm-linux-androideabi
ARG ARM_V7_TARGET=armv7a-linux-androideabi
ARG ARM64_TARGET=aarch64-linux-android
ARG X86_TARGET=i686-linux-android
ARG X86_64_TARGET=x86_64-linux-android

ARG ARM_TOOLCHAIN="   PATH=${TOOLCHAIN_BIN}:${PATH} AR=${TOOLCHAIN_BIN}/${ARM_TARGET}-ar    AS=${TOOLCHAIN_BIN}/${ARM_TARGET}-as    CC=${TOOLCHAIN_BIN}/${ARM_V7_TARGET}${ANDROID_API}-clang CXX=${TOOLCHAIN_BIN}/${ARM_V7_TARGET}${ANDROID_API}-clang++ LD=${TOOLCHAIN_BIN}/${ARM_TARGET}-ld    RANLIB=${TOOLCHAIN_BIN}/${ARM_TARGET}-ranlib    STRIP=${TOOLCHAIN_BIN}/${ARM_TARGET}-strip"
ARG ARM64_TOOLCHAIN=" PATH=${TOOLCHAIN_BIN}:${PATH} AR=${TOOLCHAIN_BIN}/${ARM64_TARGET}-ar  AS=${TOOLCHAIN_BIN}/${ARM64_TARGET}-as  CC=${TOOLCHAIN_BIN}/${ARM64_TARGET}${ANDROID_API}-clang  CXX=${TOOLCHAIN_BIN}/${ARM64_TARGET}${ANDROID_API}-clang++  LD=${TOOLCHAIN_BIN}/${ARM64_TARGET}-ld  RANLIB=${TOOLCHAIN_BIN}/${ARM64_TARGET}-ranlib  STRIP=${TOOLCHAIN_BIN}/${ARM64_TARGET}-strip"
ARG X86_TOOLCHAIN="   PATH=${TOOLCHAIN_BIN}:${PATH} AR=${TOOLCHAIN_BIN}/${X86_TARGET}-ar    AS=${TOOLCHAIN_BIN}/${X86_TARGET}-as    CC=${TOOLCHAIN_BIN}/${X86_TARGET}${ANDROID_API}-clang    CXX=${TOOLCHAIN_BIN}/${X86_TARGET}${ANDROID_API}-clang++    LD=${TOOLCHAIN_BIN}/${X86_TARGET}-ld    RANLIB=${TOOLCHAIN_BIN}/${X86_TARGET}-ranlib    STRIP=${TOOLCHAIN_BIN}/${X86_TARGET}-strip"
ARG X86_64_TOOLCHAIN="PATH=${TOOLCHAIN_BIN}:${PATH} AR=${TOOLCHAIN_BIN}/${X86_64_TARGET}-ar AS=${TOOLCHAIN_BIN}/${X86_64_TARGET}-as CC=${TOOLCHAIN_BIN}/${X86_64_TARGET}${ANDROID_API}-clang CXX=${TOOLCHAIN_BIN}/${X86_64_TARGET}${ANDROID_API}-clang++ LD=${TOOLCHAIN_BIN}/${X86_64_TARGET}-ld RANLIB=${TOOLCHAIN_BIN}/${X86_64_TARGET}-ranlib STRIP=${TOOLCHAIN_BIN}/${X86_64_TARGET}-strip"

# Download OpenSSL
ARG OPENSSL_VERSION=1.1.1h
ARG OPENSSL_HASH_1_1_1g=ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46
ARG OPENSSL_HASH=5c9ca8774bd7b03e5784f26ae9e9e6d749c9da2438545077e6b3d755a06595d9
RUN set -ex \
    && cd /opt/android \
    && curl -L -s -O https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && echo "${OPENSSL_HASH}  openssl-${OPENSSL_VERSION}.tar.gz" | sha256sum -c \
    && tar xf openssl-${OPENSSL_VERSION}.tar.gz \
    && mv openssl-${OPENSSL_VERSION} openssl

# Build OpenSSL
RUN set -ex \
    && cd /opt/android/openssl \
    && export CONFIG_ARGS=" no-shared no-capieng no-dso no-dtls1 no-ec_nistp_64_gcc_128 no-gost " \
    && export CONFIG_ARGS="${CONFIG_ARGS} no-heartbeats no-md2 no-rc5 no-rdrand no-rfc3779 no-sctp no-ssl-trace no-ssl2 no-ssl3 " \
    && export CONFIG_ARGS="${CONFIG_ARGS} no-static-engine no-tests no-weak-ssl-ciphers no-zlib-dynamic" \
    && export ARM_CONFIG_ARGS="--prefix=${ARM_BUILD_FOLDER} android-arm -D__ANDROID_API__=${ANDROID_API}" \
    && export ARM64_CONFIG_ARGS="--prefix=${ARM64_BUILD_FOLDER} android-arm64 -D__ANDROID_API__=${ANDROID_API}" \
    && export X86_CONFIG_ARGS="--prefix=${X86_BUILD_FOLDER} android-x86 -D__ANDROID_API__=${ANDROID_API}" \
    && export X86_64_CONFIG_ARGS="--prefix=${X86_64_BUILD_FOLDER} android-x86_64 -D__ANDROID_API__=${ANDROID_API}" \
    && export ANDROID_NDK_HOME=/opt/android/ndk \
    && export PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH \
    && ./Configure ${CONFIG_ARGS} ${ARM_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && ./Configure ${CONFIG_ARGS} ${ARM64_CONFIG_ARGS}  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && ./Configure ${CONFIG_ARGS} ${X86_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && ./Configure ${CONFIG_ARGS} ${X86_64_CONFIG_ARGS} && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Download Boost
ARG BOOST_VERSION=1_74_0
ARG BOOST_VERSION_DOT=1.74.0
RUN cd /opt/android \
    && curl -s -L -o  boost_${BOOST_VERSION}.tar.bz2 https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION_DOT}/boost_${BOOST_VERSION}.tar.bz2/download \
    && tar -xvf boost_${BOOST_VERSION}.tar.bz2 \
    && rm -f /usr/boost_${BOOST_VERSION}.tar.bz2 \
    && cd boost_${BOOST_VERSION} \
    && ./bootstrap.sh

# Boost Build Config
RUN cd boost_${BOOST_VERSION} \
    && rm -f arm.jam \
    && echo "import os ;" >> arm.jam \
    && echo "using clang : android" >> arm.jam \
    && echo ":" >> arm.jam \
    && echo "${TOOLCHAIN_BIN}/${ARM_V7_TARGET}${ANDROID_API}-clang++" >> arm.jam \
    && echo ":" >> arm.jam \
    && echo "<archiver>${TOOLCHAIN_BIN}/${ARM_TARGET}-ar" >> arm.jam \
    && echo "<ranlib>${TOOLCHAIN_BIN}/${ARM_TARGET}-ranlib" >> arm.jam \
    && echo ";" >> arm.jam \
    \
    && echo "import os ;" >> arm64.jam \
    && echo "using clang : android" >> arm64.jam \
    && echo ":" >> arm64.jam \
    && echo "${TOOLCHAIN_BIN}/${ARM64_TARGET}${ANDROID_API}-clang++" >> arm64.jam \
    && echo ":" >> arm64.jam \
    && echo "<archiver>${TOOLCHAIN_BIN}/${ARM64_TARGET}-ar" >> arm64.jam \
    && echo "<ranlib>${TOOLCHAIN_BIN}/${ARM64_TARGET}-ranlib" >> arm64.jam \
    && echo ";" >> arm64.jam \
    \
    && echo "import os ;" >> x86.jam \
    && echo "using clang : android" >> x86.jam \
    && echo ":" >> x86.jam \
    && echo "${TOOLCHAIN_BIN}/${X86_TARGET}${ANDROID_API}-clang++" >> x86.jam \
    && echo ":" >> x86.jam \
    && echo "<archiver>${TOOLCHAIN_BIN}/${X86_TARGET}-ar" >> x86.jam \
    && echo "<ranlib>${TOOLCHAIN_BIN}/${X86_TARGET}-ranlib" >> x86.jam \
    && echo ";" >> x86.jam \
    \
    && echo "import os ;" >> x86_64.jam \
    && echo "using clang : android" >> x86_64.jam \
    && echo ":" >> x86_64.jam \
    && echo "${TOOLCHAIN_BIN}/${X86_64_TARGET}${ANDROID_API}-clang++" >> x86_64.jam \
    && echo ":" >> x86_64.jam \
    && echo "<archiver>${TOOLCHAIN_BIN}/${X86_64_TARGET}-ar" >> x86_64.jam \
    && echo "<ranlib>${TOOLCHAIN_BIN}/${X86_64_TARGET}-ranlib" >> x86_64.jam \
    && echo ";" >> x86_64.jam

# Build Boost
RUN cd boost_${BOOST_VERSION} \
    && export CONFIG_ARGS=" -j${BUILD_JOBS} --build-type=minimal link=static runtime-link=static --with-atomic --with-chrono --with-date_time --with-filesystem --with-program_options --with-regex --with-serialization --with-system --with-thread threading=multi threadapi=pthread target-os=android toolset=clang-android cxxflags=-fPIC" \
    && ./b2 --build-dir=android-arm    --prefix=${ARM_BUILD_FOLDER}    --user-config=arm.jam    ${CONFIG_ARGS} install \
    && ./b2 --build-dir=android-arm64  --prefix=${ARM64_BUILD_FOLDER}  --user-config=arm64.jam  ${CONFIG_ARGS} install \
    && ./b2 --build-dir=android-x86    --prefix=${X86_BUILD_FOLDER}    --user-config=x86.jam    ${CONFIG_ARGS} install \
    && ./b2 --build-dir=android-x86_64 --prefix=${X86_64_BUILD_FOLDER} --user-config=x86_64.jam ${CONFIG_ARGS} install

# Download Sodium
ARG SODIUM_VERSION=1.0.18-RELEASE
ARG SODIUM_HASH=940ef42797baa0278df6b7fd9e67c7590f87744b
RUN set -ex \
    && cd /opt/android \
    && git clone https://github.com/jedisct1/libsodium.git -b ${SODIUM_VERSION} --depth=1 \
    && cd libsodium \
    && test `git rev-parse HEAD` = ${SODIUM_HASH} || exit 1 \
    && ./autogen.sh

# Build Sodium
RUN cd /opt/android/libsodium \
    && export CONFIG_ARGS="--enable-static --disable-shared --with-pic" \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    && make -j${BUILD_JOBS} && make install && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  && make -j${BUILD_JOBS} && make install && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    && make -j${BUILD_JOBS} && make install && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} --prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} && make -j${BUILD_JOBS} && make install && make clean

# Download SQLite
ARG SQLITE_VERSION=3310100
ARG SQLITE_HASH=62284efebc05a76f909c580ffa5c008a7d22a1287285d68b7825a2b6b51949ae
RUN set -ex \
    && cd /opt/android \
    && curl -s -O https://sqlite.org/2020/sqlite-autoconf-${SQLITE_VERSION}.tar.gz \
    && echo "${SQLITE_HASH}  sqlite-autoconf-${SQLITE_VERSION}.tar.gz" | sha256sum -c \
    && tar xf sqlite-autoconf-${SQLITE_VERSION}.tar.gz \
    && mv sqlite-autoconf-${SQLITE_VERSION} sqlite

# Build SQLite
RUN cd /opt/android/sqlite \
    && export CONFIG_ARGS="--enable-static --disable-shared --with-pic" \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    && make -j${BUILD_JOBS} && make install && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  && make -j${BUILD_JOBS} && make install && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    && make -j${BUILD_JOBS} && make install && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} --prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} && make -j${BUILD_JOBS} && make install && make clean

# Download ZMQ
ARG ZMQ_VERSION=v4.3.2
ARG ZMQ_HASH=a84ffa12b2eb3569ced199660bac5ad128bff1f0
RUN set -ex \
    && cd /opt/android \
    && git clone https://github.com/zeromq/libzmq.git -b ${ZMQ_VERSION} --depth=1 \
    && cd libzmq \
    && test `git rev-parse HEAD` = ${ZMQ_HASH} || exit 1 \
    && ./autogen.sh

# Build ZMQ
RUN cd /opt/android/libzmq \
    && export CONFIG_ARGS="--enable-static --disable-shared --disable-curve-keygen --enable-curve --disable-drafts --disable-libunwind --without-pgm --without-norm --without-vmci --without-docs --with-pic " \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    --with-libsodium=${ARM_BUILD_FOLDER}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  --with-libsodium=${ARM64_BUILD_FOLDER}  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    --with-libsodium=${X86_BUILD_FOLDER}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} --prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} --with-libsodium=${X86_64_BUILD_FOLDER} && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Download Expat (Unbound dependency)
ARG EXPAT_VERSION_DOT=2.2.9
ARG EXPAT_VERSION=2_2_9
ARG EXPAT_HASH=1ea6965b15c2106b6bbe883397271c80dfa0331cdf821b2c319591b55eadc0a4
RUN set -ex \
    && cd /opt/android \
    && export NAME=expat-${EXPAT_VERSION_DOT} \
    && export ARCHIVE=${NAME}.tar.xz \
    && curl -L -s -O https://github.com/libexpat/libexpat/releases/download/R_${EXPAT_VERSION}/${ARCHIVE} \
    && echo "${EXPAT_HASH}  ${ARCHIVE}" | sha256sum -c \
    && tar xf ${ARCHIVE} \
    && mv ${NAME} expat

# Build Expat
RUN cd /opt/android/expat \
    && export CONFIG_ARGS="--enable-static --disable-shared --with-pic --without-examples --without-tests --without-docbook --without-xmlwf" \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} --prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Download Unbound
ARG UNBOUND_VERSION=1.12.0
ARG UNBOUND_HASH_1_12_0=5b9253a97812f24419bf2e6b3ad28c69287261cf8c8fa79e3e9f6d3bf7ef5835
RUN set -ex \
    && cd /opt/android \
    && curl -s -O https://nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz \
    && tar xf unbound-${UNBOUND_VERSION}.tar.gz \
    && mv unbound-${UNBOUND_VERSION} unbound

# Build Unbound
RUN cd /opt/android/unbound \
    && export CONFIG_ARGS="--enable-static --disable-shared --with-pic --with-libunbound-only --enable-flto --with-pic" \
    && export ARM_CONFIG_ARGS="   --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    --with-libexpat=${ARM_BUILD_FOLDER}    --with-ssl=${ARM_BUILD_FOLDER}" \
    && export ARM64_CONFIG_ARGS=" --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  --with-libexpat=${ARM64_BUILD_FOLDER}  --with-ssl=${ARM64_BUILD_FOLDER}" \
    && export X86_CONFIG_ARGS="   --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    --with-libexpat=${X86_BUILD_FOLDER}    --with-ssl=${X86_BUILD_FOLDER}" \
    && export X86_64_CONFIG_ARGS="--prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} --with-libexpat=${X86_64_BUILD_FOLDER} --with-ssl=${X86_64_BUILD_FOLDER}" \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${ARM_CONFIG_ARGS}    && cp contrib/libunbound.pc ${ARM_BUILD_FOLDER}/lib/pkgconfig    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} ${ARM64_CONFIG_ARGS}  && cp contrib/libunbound.pc ${ARM64_BUILD_FOLDER}/lib/pkgconfig  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${X86_CONFIG_ARGS}    && cp contrib/libunbound.pc ${X86_BUILD_FOLDER}/lib/pkgconfig    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} ${X86_64_CONFIG_ARGS} && cp contrib/libunbound.pc ${X86_64_BUILD_FOLDER}/lib/pkgconfig && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Download ZLIB (Curl dependency)
ARG ZLIB_VERSION=1.2.11
ARG ZLIB_HASH=73fd3fff4adeccd4894084c15ddac89890cd10ef105dd5e1835e1e9bbb6a49ff229713bd197d203edfa17c2727700fce65a2a235f07568212d820dca88b528ae
RUN set -ex \
    && cd /opt/android \
    && curl -L -s -O https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
    && echo "${ZLIB_HASH}  zlib-${ZLIB_VERSION}.tar.gz" | sha512sum -c \
    && tar xf zlib-${ZLIB_VERSION}.tar.gz \
    && mv zlib-${ZLIB_VERSION} zlib

# Build ZLIB
RUN cd /opt/android/zlib \
    && export CONFIG_ARGS="--static" \
    && export ARM_CONFIG_ARGS="--prefix=${ARM_BUILD_FOLDER} " \
    && export ARM64_CONFIG_ARGS="--prefix=${ARM64_BUILD_FOLDER} " \
    && export X86_CONFIG_ARGS="--prefix=${X86_BUILD_FOLDER} " \
    && export X86_64_CONFIG_ARGS="--prefix=${X86_64_BUILD_FOLDER} " \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${ARM_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} ${ARM64_CONFIG_ARGS}  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${X86_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} ${X86_64_CONFIG_ARGS} && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Download Curl
ARG CURL_VERSION=7.72.0
ARG CURL_HASH=0ded0808c4d85f2ee0db86980ae610cc9d165e9ca9da466196cc73c346513713
RUN set -ex \
    && cd /opt/android \
    && curl -L -s -O https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.xz \
    && echo "${CURL_HASH}  curl-${CURL_VERSION}.tar.xz" | sha256sum -c \
    && tar xf curl-${CURL_VERSION}.tar.xz \
    && mv curl-${CURL_VERSION} curl

# Build Curl
RUN cd /opt/android/curl \
    && export CONFIG_ARGS="--disable-shared --enable-static              --disable-ares              --disable-ftp               --disable-ldap" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --disable-telnet             --disable-tftp              --disable-pop3              --disable-imap" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --disable-smtp               --disable-gopher            --disable-manual            --disable-libcurl-option" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --enable-http                --enable-ipv6               --disable-threaded-resolver --disable-pthreads" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --disable-verbose            --disable-sspi              --enable-crypto-auth        --disable-ntlm-wb" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --disable-tls-srp            --disable-unix-sockets      --disable-cookies           --enable-http-auth " \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --enable-doh                 --disable-mime              --enable-dateparse          --disable-netrc " \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --without-libidn2            --disable-progress-meter    --without-brotli            --disable-rtsp" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --without-libmetalink        --without-librtmp           --disable-versioned-symbols " \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --enable-hidden-symbols      --without-zsh-functions-dir --disable-laps" \
    && export CONFIG_ARGS="${CONFIG_ARGS}   --without-fish-functions-dir --disable-dict              --disable-smb" \
    && export ARM_CONFIG_ARGS="   --prefix=${ARM_BUILD_FOLDER}    --host=${ARM_TARGET}    --with-zlib=${ARM_BUILD_FOLDER} " \
    && export ARM64_CONFIG_ARGS=" --prefix=${ARM64_BUILD_FOLDER}  --host=${ARM64_TARGET}  --with-zlib=${ARM64_BUILD_FOLDER} " \
    && export X86_CONFIG_ARGS="   --prefix=${X86_BUILD_FOLDER}    --host=${X86_TARGET}    --with-zlib=${X86_BUILD_FOLDER} " \
    && export X86_64_CONFIG_ARGS="--prefix=${X86_64_BUILD_FOLDER} --host=${X86_64_TARGET} --with-zlib=${X86_64_BUILD_FOLDER} " \
    && export ${ARM_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${ARM_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${ARM64_TOOLCHAIN}  && ./configure ${CONFIG_ARGS} ${ARM64_CONFIG_ARGS}  && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_TOOLCHAIN}    && ./configure ${CONFIG_ARGS} ${X86_CONFIG_ARGS}    && make -j${BUILD_JOBS} && make install && ldconfig && make clean \
    && export ${X86_64_TOOLCHAIN} && ./configure ${CONFIG_ARGS} ${X86_64_CONFIG_ARGS} && make -j${BUILD_JOBS} && make install && ldconfig && make clean

# Building Loki from the latest commit on Android branch, this should be kept up to date with master
# with the necessary fixes by crtlib and m2049r to build for mobile.
# RUN cd /opt/android \
#     && git clone -b android https://github.com/loki-project/loki.git --recursive --depth=1 \
#     && cd loki \
#     && mkdir -p build/release \
#     && ./build-all-arch.sh

# Uncomment this section to use loki from the docker directory if you want to
# easily build a custom version not depending on the specified branch above and
# comment out the section above that pulls from github.
ADD loki /opt/android/loki
RUN cd /opt/android/loki \
     && rm -rf build \
     && mkdir -p build/release \
     && ./build-all-arch.sh
