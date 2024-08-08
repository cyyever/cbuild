cd ${SRC_DIR}

if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e '/exp10/d' src/libkernel/sscp/host/math.cpp
  ${sed_cmd} -i -e '/fmaxmag/d' src/libkernel/sscp/host/math.cpp
fi
