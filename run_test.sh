rm -f run_test.out

g++ -std=c++11 -fopenmp run_test.cc \
  -lfaiss_c -lfaiss -llapack -lblas -lgfortran \
  -I ./build/include \
  -L ./build/lib64 \
  -o run_test.out

if [ -f run_test.out ]; then
  ./run_test.out
else
  echo 'compile test fail'
  exit 1
fi
