cd ${SRC_DIR}
if test -f inttypes.h
then
  mv inttypes.h inttypes2.h
fi
${sed_cmd} -e 's/inttypes.h/inttypes2.h/g' -i elf/elf.h macho/macho.h mold.h elf/lto.h
# ${sed_cmd} -e 's/X86_64 I386 ARM64 ARM32 RV32LE RV32BE RV64LE RV64BE PPC64V2 SPARC64/X86_64 I386/g' -i CMakeLists.txt
