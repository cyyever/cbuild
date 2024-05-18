export CUDNN_ROOT_DIR=~/.local/lib/python${PYTHONVERSION}/site-packages/nvidia/cudnn
cp ${CUDNN_ROOT_DIR}/lib/libcudnn.so.9 ${CUDNN_ROOT_DIR}/lib/libcudnn.so
