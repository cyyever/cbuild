cd ${SRC_DIR}
${sed_cmd} -i -e "/PILLOW_VERSION = /d" test/*py
${sed_cmd} -i -e "s/if PILLOW_VERSION >[^)]*)/if True/" test/*py
rm -rf build
