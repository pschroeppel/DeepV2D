TF_CFLAGS=( $(python -c 'import tensorflow.compat.v1 as tf; print(" ".join(tf.sysconfig.get_compile_flags()))') )
TF_LFLAGS=( $(python -c 'import tensorflow.compat.v1 as tf; print(" ".join(tf.sysconfig.get_link_flags()))') )


CUDALIB=/misc/software/cuda/cuda_11.1.0/cuda/targets/x86_64-linux/lib

echo $TF_CFLAGS
echo
echo $TF_LFLAGS
echo
echo $CUDALIB

nvcc -std=c++11 -c -o backproject_op_gpu.cu.o backproject_op_gpu.cu.cc ${TF_CFLAGS[@]} -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

echo next g++

g++-9 -std=c++11 -shared -o backproject.so backproject_op.cc \
  backproject_op_gpu.cu.o ${TF_CFLAGS[@]} -D GOOGLE_CUDA=1 -fPIC -lcudart  -L${CUDALIB} ${TF_LFLAGS[@]}

