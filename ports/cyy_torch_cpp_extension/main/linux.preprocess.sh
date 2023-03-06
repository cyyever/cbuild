${sed_cmd} -i -e '/torch_cuda_get_nvcc_gencode_flag/d' $(${CBUILD_PYTHON_EXE} -c "import torch ; print(torch.__path__[0])")/share/cmake/Caffe2/public/cuda.cmake
