#!/bin/bash

# build.sh

rm -rf build
mkdir build
cd build
cmake ..
make -j12
cd ..
cp build/_deps/essentials-build/lib/pygunrock.so ./