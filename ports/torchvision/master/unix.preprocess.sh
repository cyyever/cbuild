cd ${SRC_DIR}
sed -e 's/, "torch"//g' -i pyproject.toml
sed -e 's/pytorch_dep,//g' -i setup.py
sed -e 's/"numpy",//g' -i setup.py
rm -rf build
