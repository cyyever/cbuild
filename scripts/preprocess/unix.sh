sudo_cmd=sudo
if [[ $EUID -eq 0 ]]; then
  sudo_cmd=''
fi

sed_cmd=sed
if command -v gsed >/dev/null; then
  sed_cmd=gsed
fi

make_cmd="make"
if command -v gmake >/dev/null; then
  make_cmd="gmake"
fi

# if test -d "${INSTALL_PREFIX}/python"; then
#   export PYTHONHOME="${INSTALL_PREFIX}/python"
# fi
