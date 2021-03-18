#!/bin/bash

# build.sh

# git clone https://github.com/pybind/pybind11

# --
# Build

rm -rf externals
rm -rf build
rm -f pygunrock.so

mkdir build
cd build
cmake ..
make -j12
cd ..
cp build/_deps/essentials-build/lib/pygunrock.so ./