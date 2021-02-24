${sudo_cmd} portsnap auto
${sudo_cmd} freebsd-update fetch
${sudo_cmd} freebsd-update install || true

if ! test -e /usr/local/bin/nproc; then
  sudo ln -s /usr/local/bin/gnproc /usr/local/bin/nproc
fi

for key in "if_ath_load" "if_wi_load" "wlan_wep_load" "wlan_ccmp_load" "wlan_tkip_load"; do
  if ! grep -q "${key}" /boot/loader.conf; then
    printf "%s=\"YES\"\n" "$key" | sudo tee -a /boot/loader.conf
  fi
done

sudo kldload -n linux
sudo kldload -n linux64

if ! grep -q 'linux_enable' /etc/rc.conf; then
  sudo bash -c 'echo "linux_enable=\"YES\"" >> /etc/rc.conf'
fi

if test -f /etc/fstab; then
  for line in 'linsysfs    /compat/linux/sys	linsysfs	rw	0	0' 'linprocfs   /compat/linux/proc	linprocfs	rw	0	0' 'tmpfs    /compat/linux/dev/shm	tmpfs	rw,mode=1777	0	0'; do
    if ! grep "$line" /etc/fstab; then
      printf "%s\n" "$line" | sudo tee -a /etc/fstab
    fi
  done
  ${sudo_cmd} mount -a
fi
