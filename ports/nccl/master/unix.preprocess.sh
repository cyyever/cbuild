cd ${SRC_DIR}
${sed_cmd} -i -e 's/-lcudart /-lcudart -lcudadevrt /g' makefiles/common.mk
