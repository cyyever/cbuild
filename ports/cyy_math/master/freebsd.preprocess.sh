cd ${SRC_DIR}
for file in $(find . -name '*.hpp') $(find . -name '*.cpp'); do
  ${sed_cmd} -i -e 's/using edge_type = tree/using edge_type = typename tree/g'  $file
  ${sed_cmd} -i -e 's/using weight_type = graphType/using weight_type = typename graphType/g'  $file
done
