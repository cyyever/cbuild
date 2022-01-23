cd ${env:SRC_DIR}
sed_cmd -i -e '/cuda[0-9]* = /d' setup.cfg
sed_cmd -i -e '/cupy/d' setup.cfg
