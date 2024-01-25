export PACKAGE_VERSION=6.2
cd ${SRC_DIR}
mvn --projects languagetool-standalone --also-make clean package -DskipTests
rm -rf $INSTALL_PREFIX/languagetool
mv languagetool-standalone/target/LanguageTool-${PACKAGE_VERSION}/LanguageTool-${PACKAGE_VERSION} $INSTALL_PREFIX/languagetool
