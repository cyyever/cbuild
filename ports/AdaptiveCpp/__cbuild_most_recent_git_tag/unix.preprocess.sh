cd ${SRC_DIR}


if [[ "$(uname)" == "FreeBSD" ]]; then
  ${sed_cmd} -i -e 's/!defined(__APPLE__)/0/g' $(grep '!defined(__APPLE__)' -r * -l)
fi

