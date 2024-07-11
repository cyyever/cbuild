for pkg in ${npm_pkgs}; do
  npm install --prefix "${INSTALL_PREFIX}" ${pkg}@latest
done
cd $INSTALL_PREFIX
npm update || true
npm audit fix || true
