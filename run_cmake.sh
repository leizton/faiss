#!/bin/sh

/bin/sh run_build_blas.sh
if [ $? -ne 0 ]; then
  echo 'build blas fail'
  exit 1
fi
echo 'build blas succ'
curr_dir=`pwd`
lapack_dir="$curr_dir/blas/lapack-3.12.0"
echo '------------------------------'

rm -rf build
cmake -DBLAS_LIBRARIES=$lapack_dir -DLAPACK_LIBRARIES=$lapack_dir \
 -DFAISS_ENABLE_GPU=OFF -DFAISS_ENABLE_PYTHON=OFF -DBUILD_TESTING=OFF \
 -DFAISS_ENABLE_C_API=ON -DCMAKE_BUILD_TYPE=Release \
 -DFAISS_OPT_LEVEL=generic \
 -B build .
if [ $? -ne 0 ]; then
  echo 'cmake build fail'
  exit 1
fi
echo 'cmake build succ'
echo '------------------------------'

make -j 20 -C build
echo 'make succ'
echo '------------------------------'

