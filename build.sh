#!/bin/bash

# build.sh

# git clone https://github.com/pybind/pybind11

# --
# Build

rm pygunrock.so
rm -rf build
rm -rf externals

mkdir build
cd build
~/cmake-3.19.7-Linux-x86_64/bin/cmake ..
make -j20
cd ..
cp build/_deps/essentials-build/lib/pygunrock.so ./