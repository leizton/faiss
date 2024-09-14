#!/bin/bash

cd blas
rm -rf lapack-3.12.0
tar -zxf lapack-3.12.0.tar.gz
cd lapack-3.12.0
cp make.inc.example make.inc
make -j 10 blaslib
make -j 10 cblaslib
make -j 10 lapacklib
make -j 10 lapackelib
if [ -f librefblas.a ]; then
  echo 'make succ: librefblas.a'
else
  echo 'make fail: librefblas.a'
  exit 1
fi
if [ -f libcblas.a ]; then
  echo 'make succ: libcblas.a'
else
  echo 'make fail: libcblas.a'
  exit 1
fi
if [ -f liblapack.a ]; then
  echo 'make succ: liblapack.a'
else
  echo 'make fail: liblapack.a'
  exit 1
fi
if [ -f liblapacke.a ]; then
  echo 'make succ: liblapacke.a'
else
  echo 'make fail: liblapacke.a'
  exit 1
fi
cd ..
cd ..
exit 0
