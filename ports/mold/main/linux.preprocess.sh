cd ${SRC_DIR}
if test -f inttypes.h
then
  mv inttypes.h inttypes2.h
fi
${sed_cmd} -e 's/inttypes.h/inttypes2.h/g' -i elf/elf.h macho/macho.h mold.h
