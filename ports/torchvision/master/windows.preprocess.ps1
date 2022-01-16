cd $env:SRC_DIR
sed_cmd -i -e "/image_link_flags/s/jpeg/turbojpeg/g" setup.py
sed_cmd -i -e "/image_link_flags/s/libpng/libpng16/g" setup.py
sed_cmd -i -e "s/install_requires=requirements/install_requires=[]/" setup.py
