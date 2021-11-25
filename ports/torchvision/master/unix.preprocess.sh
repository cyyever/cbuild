cd ${SRC_DIR}
${sed_cmd} -i -e "s/image_link_flags.append('jpeg')/image_link_flags.append('turbojpeg')/g" setup.py
${sed_cmd} -i -e "s#include_dirs=image_include#include_dirs=\[\"$INSTALL_PREFIX/include\"\]+image_include#g" setup.py
${sed_cmd} -i -e "s#library_dirs=image_library#library_dirs=\[\"$INSTALL_PREFIX/lib64\"\]+library_dirs#g" setup.py
${sed_cmd} -i -e "s/install_requires=requirements/install_requires=[]/" setup.py
${sed_cmd} -i -e "s#c++14#c++20#g" setup.py
rm -rf build
