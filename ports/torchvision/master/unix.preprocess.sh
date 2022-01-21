cd ${SRC_DIR}
${sed_cmd} -i -e 's/image_link_flags.append("jpeg")/image_link_flags.append("turbojpeg")/g' setup.py
${sed_cmd} -i -e "s/install_requires=requirements/install_requires=[]/" setup.py
${sed_cmd} -i -e "s#c++14#c++20#g" setup.py
${sed_cmd} -i -e "s/if has_ffmpeg/if False/g" setup.py
rm -rf build
