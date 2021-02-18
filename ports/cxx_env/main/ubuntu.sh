if [[ "${BUILD_CONTEXT_docker:=0}" == 1 ]]; then
  ${sudo_cmd} apt-get install g++-10 gcc-10 -y
  ${sudo_cmd} update-alternatives --set g++ /usr/bin/g++-10
  ${sudo_cmd} update-alternatives --set gcc /usr/bin/gcc-10
fi
