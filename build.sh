#!/bin/bash
# usage: build [version] [stack]
set -e

version=$1
stack=$2
build=`mktemp -d`

tar -C $build --strip-components=1 -xj -f /wrk/src/jemalloc-$version.tar.bz2

cd $build
./configure --prefix=/app/vendor/jemalloc
make install_bin install_include install_lib_shared install_lib_static

# Bundle and compress the compiled library
mkdir -p /wrk/dist/$stack
tar -C /app/vendor/jemalloc -jc -f /wrk/dist/$stack/jemalloc-$version.tar.bz2 .
