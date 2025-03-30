cd $SRC_DIR
sed -i -e 's/include.*synctex_parser.h/include<synctex_parser.h>/g' zathura/**/*
