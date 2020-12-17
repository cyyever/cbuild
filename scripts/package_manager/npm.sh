for pkg in ${npm_pkgs}; do
  npm install --prefix "${INSTALL_PREFIX}" ${pkg}
done
cd $INSTALL_PREFIX
npm audit fix || true
