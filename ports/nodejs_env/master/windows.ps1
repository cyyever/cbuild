cd $env:INSTALL_PREFIX
npm init --yes
npm i --package-lock-only
npm audit fix
