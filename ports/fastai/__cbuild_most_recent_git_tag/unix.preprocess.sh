cd ${SRC_DIR}
${sed_cmd} -i -e "/pip_require/d" settings.ini
${sed_cmd} -i -e "s/torchvision>=[^ ]*//g" settings.ini
