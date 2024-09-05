cd ${SRC_DIR}
${sed_cmd} -i -e '/go:generate.*floats_avx/d' base/floats/floats_amd64.go
