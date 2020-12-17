if command -v stack > /dev/null; then
  stack upgrade
  exit 0
fi
curl -sSL https://get.haskellstack.org/ | sh
