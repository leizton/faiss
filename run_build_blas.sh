#!/bin/bash

cd blas
rm -rf lapack-3.12.0
tar -zxf lapack-3.12.0.tar.gz
cd lapack-3.12.0

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_INSTALL_PREFIX=./build \
  -B build .

make -j 10 -C build
make install -C build

if [ -f ./build/lib64/libblas.a ]; then
  echo 'make succ: librefblas.a'
else
  echo 'make fail: librefblas.a'
  exit 1
fi

if [ -f ./build/lib64/liblapack.a ]; then
  echo 'make succ: liblapack.a'
else
  echo 'make fail: liblapack.a'
  exit 1
fi

cd ..
cd ..
exit 0
