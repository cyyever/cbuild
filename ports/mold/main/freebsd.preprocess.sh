cd ${SRC_DIR}
gsed -e '/alloca\.h/d' -i elf/mold-wrapper.c
