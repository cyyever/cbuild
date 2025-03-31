cd $SRC_DIR
sed -i -e 's/include.*synctex_parser.h>/include <synctex_parser.h>/g' $(grep synctex_parser.h -r zathura -l)
