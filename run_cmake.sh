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
  -DCMAKE_INSTALL_PREFIX=$curr_dir/build \
  -B build .
if [ $? -ne 0 ]; then
  echo 'cmake build fail'
  exit 1
fi
echo 'cmake build succ'
echo '------------------------------'

make -j 10 -C build
echo 'make succ'
echo '------------------------------'

make install -C build
cp ./build/c_api/libfaiss_c.a build/lib64/
cp blas/lapack-3.12.0/lib*.a build/lib64/
echo 'install succ'
echo '------------------------------'
