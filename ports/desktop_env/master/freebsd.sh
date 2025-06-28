if test -f /etc/fstab; then
  if ! grep 'proc' /etc/fstab; then
    printf "proc           /proc       procfs  rw  0   0\n" | sudo tee -a /etc/fstab
  fi
fi

for key in "dbus_enable" "hald_enable" "webcamd_enable" "ntpdate_enable" "seatd_enable" "hcsecd_enable" "bthidd_enable" "sddm_enable"; do
  sudo sysrc ${key}=YES
done
for key in "cuse_load==\"YES\"" "webcamd_0_flags=\"-d ugen1.5\""; do
  if ! grep -q "${key}" /boot/loader.conf; then
    printf "%s\n" "${key}" | sudo tee -a /boot/loader.conf
  fi
done

: >~/.xprofile
for line in "export GTK_IM_MODULE=ibus" "export XMODIFIERS=@im=ibus" "export QT_IM_MODULE=ibus" "ibus-daemon -x -d"; do
  printf "%s\n" "$line" | tee -a ~/.xprofile
done
