cd $env:SRC_DIR
mvn --projects languagetool-standalone --also-make clean package -DskipTests
mkdir -Force $env:INSTALL_PREFIX/languagetool
rm -r -Force $env:INSTALL_PREFIX/languagetool
mv languagetool-standalone/target/LanguageTool-5.0-SNAPSHOT/LanguageTool-5.0-SNAPSHOT $env:INSTALL_PREFIX/languagetool
