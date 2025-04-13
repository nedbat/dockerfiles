# Make an image for building CPython

FROM nedbat/base

ARG APT_INSTALL="apt-get install -y --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN \
    sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources* && \
    apt-get update && \
    :

# https://devguide.python.org/getting-started/setup-building/#install-dependencies
RUN \
    apt-get -y build-dep python3 && \
    $APT_INSTALL build-essential gdb lcov pkg-config \
        libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
        libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
        lzma lzma-dev tk-dev uuid-dev zlib1g-dev && \
    :

RUN \
    mkdir /usr/local/cpython && \
    chown me /usr/local/cpython && \
    :

USER me
WORKDIR /home/me

RUN \
    git clone https://github.com/nedbat/cpython.git && \
    cd cpython && \
    git remote add upstream https://github.com/python/cpython.git && \
    git fetch --all --prune --tags && \
    :

# Get a branch to build:
#   % git checkout --track upstream/3.13
#
#   % cat > build.sh
#   git clean -fdx .
#   ./configure --prefix=/usr/local/cpython "$@"
#   make -j
#   rm -rf /usr/local/cpython/*
#   echo make install, but quietly
#   make install >/dev/null

#
# % . ../build.sh --disable-gil
