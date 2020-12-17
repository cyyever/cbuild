for key in "if_tap_load" "if_bridge_load" "kqemu_load"; do
  if ! grep -q "${key}" /etc/rc.conf; then
    printf "%s=\"YES\"\n" "$key" | sudo tee -a /boot/loader.conf
  fi
done
