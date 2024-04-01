cd $env:SRC_DIR
sed -e '/torch/d' -i requirements/*.txt
sed -e '/numpy/d' -i requirements/*.txt
