cd ${SRC_DIR}
mvn --projects languagetool-standalone --also-make clean package -DskipTests
rm -rf $INSTALL_PREFIX/languagetool
mv languagetool-standalone/target/LanguageTool-5.4/LanguageTool-5.4 $INSTALL_PREFIX/languagetool
