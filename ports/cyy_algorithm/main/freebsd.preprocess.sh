cd ${SRC_DIR}
for file in $(find . -name '*.hpp'); do
  ${sed_cmd} -i -e 's#include <ranges>#include <range/v3/all.hpp>#g' $file
  ${sed_cmd} -i -e 's/std::ranges::/::ranges::/g' $file
  ${sed_cmd} -i -e 's/std::views::/::ranges::views::/g' $file
  ${sed_cmd} -i -e 's/std::insert_iterator/::ranges::insert_iterator/g'  $file
  ${sed_cmd} -i -e 's/std::inserter/::ranges::inserter/g'  $file
  ${sed_cmd} -i -e 's/std::back_inserter/::ranges::back_inserter/g'  $file
done
for file in $(find . -name '*.cpp'); do
  ${sed_cmd} -i -e 's#include <ranges>#include <range/v3/all.hpp>#g' $file
  ${sed_cmd} -i -e 's/std::ranges::/::ranges::/g' $file
  ${sed_cmd} -i -e 's/std::views::/::ranges::views::/g' $file
  ${sed_cmd} -i -e 's/std::insert_iterator/::ranges::insert_iterator/g'  $file
  ${sed_cmd} -i -e 's/std::inserter/::ranges::inserter/g'  $file
  ${sed_cmd} -i -e 's/std::back_inserter/::ranges::back_inserter/g'  $file
done
