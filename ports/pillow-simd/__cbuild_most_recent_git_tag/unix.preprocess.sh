if [[ -n ${SRC_DIR+x} ]]; then
  cd ${SRC_DIR}
  ${sed_cmd} -e '/feature.want("jpeg2000")/s/feature.want("jpeg2000")/False/' -i setup.py
  ${sed_cmd} -e '/feature.want("tiff")/s/feature.want("tiff")/False/' -i setup.py
fi
