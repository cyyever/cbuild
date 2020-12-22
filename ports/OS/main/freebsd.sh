if ! test -e /usr/local/bin/nproc; then
  sudo ln -s /usr/local/bin/gnproc /usr/local/bin/nproc
fi
if ! grep -q 'linux_enable' /etc/rc.conf; then
  sudo bash -c 'echo "linux_enable=\"YES\"" >> /etc/rc.conf'
fi

for key in "if_ath_load" "if_wi_load" "wlan_wep_load" "wlan_ccmp_load" "wlan_tkip_load"; do
  if ! grep -q "${key}" /boot/loader.conf; then
    printf "%s=\"YES\"\n" "$key" | sudo tee -a /boot/loader.conf
  fi
done

sudo kldload -n linux
sudo kldload -n linux64

${sudo_cmd} portsnap auto
