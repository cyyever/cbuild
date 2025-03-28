${sudo_cmd} freebsd-update fetch || true
${sudo_cmd} freebsd-update install || true
${sudo_cmd} pkg upgrade -y

if ! test -e /usr/local/bin/nproc; then
  sudo ln -s /usr/local/bin/gnproc /usr/local/bin/nproc
fi

sudo kldload -n linux
sudo kldload -n linux64

sudo sysrc linux_enable=YES
sudo sysrc kld_list+="acpi_video"
sudo sysrc kld_list+="i915kms"
sudo pw groupmod video -m $(whoami)
sudo pw groupmod wheel -m $(whoami)

sudo mkdir -p /compat/linux/sys /compat/linux/proc /compat/linux/dev/shm
if test -f /etc/fstab; then
  for line in 'linsysfs    /compat/linux/sys	linsysfs	rw	0	0' 'linprocfs   /compat/linux/proc	linprocfs	rw	0	0' 'tmpfs    /compat/linux/dev/shm	tmpfs	rw,mode=1777	0	0'; do
    if ! grep "$line" /etc/fstab; then
      printf "%s\n" "$line" | sudo tee -a /etc/fstab
    fi
  done
  ${sudo_cmd} mount -a
fi
