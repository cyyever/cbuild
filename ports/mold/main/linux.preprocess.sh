cd ${SRC_DIR}
# ${sed_cmd} -e '/arch-arm32.cc/d' -i CMakeLists.txt
# ${sed_cmd} -e '/arch-arm64.cc/d' -i CMakeLists.txt
# ${sed_cmd} -e '/arch-riscv.cc/d' -i CMakeLists.txt
if test -f inttypes.h
then
  mv inttypes.h inttypes2.h
fi
${sed_cmd} -e 's/inttypes.h/inttypes2.h/g' -i elf/elf.h macho/macho.h mold.h
