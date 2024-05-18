cd ${SRC_DIR}
sed -e 's/, "torch"//g' -i pyproject.toml
rm -rf build
