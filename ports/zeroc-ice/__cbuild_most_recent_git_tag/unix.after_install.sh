if test -f /usr/include/Ice/Connection.h; then
  ${sudo_cmd} ${sed_cmd} -i -e 's/u8""/""/g' /usr/include/Ice/Connection.h
fi
