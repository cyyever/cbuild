cd ${SRC_DIR}
${sed_cmd} -i -e '/libcxx/d' CMakeLists.txt
for file in $(find . -name '*.hpp') $(find . -name '*.cpp'); do
  ${sed_cmd} -i -e 's#include <ranges>#include <range/v3/all.hpp>#g' $file
  ${sed_cmd} -i -e 's/std::ranges::/::ranges::/g' $file
  ${sed_cmd} -i -e 's/std::views::/::ranges::views::/g' $file
  ${sed_cmd} -i -e 's/std::insert_iterator/::ranges::insert_iterator/g'  $file
  ${sed_cmd} -i -e 's/std::inserter/::ranges::inserter/g'  $file
  ${sed_cmd} -i -e 's/std::back_inserter/::ranges::back_inserter/g'  $file
  ${sed_cmd} -i -e 's/std::convertible_to/::ranges::convertible_to/g'  $file
  ${sed_cmd} -i -e 's/using edge_type = tree/using edge_type = typename tree/g'  $file
done
${sed_cmd} -i -e 's/items.emplace_back(std::move(data), std::move(key))/items.emplace_back(item{std::move(data), std::move(key)})/g' src/heap.hpp
${sed_cmd} -i -e '/edges.emplace_back/s/edges.emplace_back(/edges.emplace_back(edge<size_t>{/g' src/graph/tree_algorithm.cpp
${sed_cmd} -i -e '/edges.emplace_back/s/);/});/g' src/graph/tree_algorithm.cpp
