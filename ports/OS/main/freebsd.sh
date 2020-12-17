if ! test -e /usr/local/bin/nproc; then
  sudo ln -s /usr/local/bin/gnproc /usr/local/bin/nproc
fi
if ! grep -q 'linux_enable' /etc/rc.conf; then
  sudo bash -c 'echo "linux_enable=\"YES\"" >> /etc/rc.conf'
fi
sudo kldload -n linux
sudo kldload -n linux64

${sudo_cmd} portsnap auto
