cd $env:SRC_DIR
C:\Strawberry\perl\bin\perl Configure VC-WIN64A --prefix=$env:INSTALL_PREFIX --openssldir=$env:INSTALL_PREFIX/SSL
nmake
nmake test
nmake install_sw
# mkdir $env:INSTALL_PREFIX/SSL
# nmake install_ssldirs
