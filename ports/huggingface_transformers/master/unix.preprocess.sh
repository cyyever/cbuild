cd ${SRC_DIR}
${sed_cmd} -i -e "/fsspec/d" setup.py
${sed_cmd} -i -e "s/_register_pytree_node/register_pytree_node/g" src/transformers/utils/generic.py
