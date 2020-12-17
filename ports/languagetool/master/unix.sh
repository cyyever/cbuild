cd ${SRC_DIR}
mvn --projects languagetool-standalone --also-make clean package -DskipTests
rm -rf $INSTALL_PREFIX/languagetool
mv languagetool-standalone/target/LanguageTool-5.2-SNAPSHOT/LanguageTool-5.2-SNAPSHOT $INSTALL_PREFIX/languagetool
