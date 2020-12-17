cd ${BUILD_DIR}

install_cmd=install
if command -v ginstall; then
  install_cmd=ginstall
fi

sharedir=/usr/share
libexecdir=/usr/libexec
if [ "$(uname)" = 'FreeBSD' ]; then
  sharedir=/usr/local/share
  libexecdir=/usr/local/libexec
fi

${sudo_cmd} ${install_cmd} -m 755 -d ${sharedir}/ibus/component
${sudo_cmd} ${install_cmd} -m 644 -t ${sharedir}/ibus/component/ ${SRC_DIR}/rime.xml
${sudo_cmd} ${install_cmd} -m 755 -d ${libexecdir}/ibus-rime
${sudo_cmd} ${install_cmd} -m 755 -t ${libexecdir}/ibus-rime/ ibus-engine-rime
${sudo_cmd} ${install_cmd} -m 755 -d ${sharedir}/ibus-rime
${sudo_cmd} ${install_cmd} -m 755 -d ${sharedir}/ibus-rime/icons
${sudo_cmd} ${install_cmd} -m 644 -t ${sharedir}/ibus-rime/icons/ ${SRC_DIR}/icons/*.png
${sudo_cmd} ${install_cmd} -m 755 -d ${sharedir}/rime-data
${sudo_cmd} ${install_cmd} -m 644 -t ${sharedir}/rime-data/ ${SRC_DIR}/ibus_rime.yaml
