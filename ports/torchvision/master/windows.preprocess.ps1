cd $env:SRC_DIR
# sed_cmd -i -e '/image_link_flags/s/"jpeg"/"turbojpeg"/g' setup.py
sed_cmd -i -e "/image_link_flags/s/libpng/libpng16/g" setup.py
sed_cmd -i -e '/library =/s/"libpng"/"libpng16"/' setup.py
# sed_cmd -i -e "s/if has_ffmpeg/if False/g" setup.py
sed_cmd -i -e "s/pytorch_dep,//g" setup.py
sed_cmd -i -e "/PILLOW_VERSION = /d" test/*py
sed_cmd -i -e "s/if PILLOW_VERSION >[^)]*)/if True/" test/*py
sed_cmd -i -e '/torch/s/"torch",//g' pyproject.toml
