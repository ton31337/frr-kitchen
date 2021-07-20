Vagrant.configure(2) do |config|
  config.vm.provision :shell, inline: 'apt update'
  config.vm.provision :shell, inline: 'apt install -y apt-transport-https'
  config.vm.provision :shell, inline: 'curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -'
  config.vm.provision :shell, inline: 'echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable | sudo tee -a /etc/apt/sources.list.d/frr.list'
  config.vm.provision :shell, inline: 'apt update'
  config.vm.provision :shell, inline: 'apt install librtr0 librtr-dev build-essential libjson-c-dev python-dev python3.5-dev libreadline-dev libc-ares-dev python-sphinx texinfo git autoconf libtool bison flex install-info python-pip realpath equivs groff fakeroot debhelper devscripts debhelper lintian systemd libpcre3-dev libpcre16-3 libpcre32-3 libpcrecpp0v5 pkg-config vim mininet iproute gdb libcap-dev systemtap-sdt-dev libelf-dev libpcre2-dev -y'
  config.vm.provision :shell, inline: 'apt update && apt install libsystemd-dev -y'
  config.vm.provision :shell, inline: 'pip install ipaddr pytest'
  config.vm.provision :shell, inline: 'addgroup --system --gid 92 frr && addgroup --system --gid 85 frrvty && adduser --system --ingroup frr --home /var/run/frr/ \
     --gecos "FRR suite" --shell /bin/false frr && usermod -a -G frrvty frr'
  config.vm.provision :shell, inline: 'git clone https://github.com/ton31337/frr /root/frr'
  config.vm.provision :shell, inline: 'wget -O /root/libyang-dev.deb https://ci1.netdef.org/artifact/LIBYANG-LIBYANGV2/shared/build-2/Debian-9-x86_64-Packages/libyang2-dev_2.0.0.10.g2eb910e4-1_amd64.deb'
  config.vm.provision :shell, inline: 'wget -O /root/libyang.deb https://ci1.netdef.org/artifact/LIBYANG-LIBYANGV2/shared/build-2/Debian-9-x86_64-Packages/libyang2_2.0.0.10.g2eb910e4-1_amd64.deb'
  config.vm.provision :shell, inline: 'dpkg -i /root/libyang-dev.deb /root/libyang.deb'
  config.vm.provision :shell, inline: 'cd /root/frr && ./bootstrap.sh'
  config.vm.provision :shell, inline: 'cd /root/frr && ./configure --enable-systemd --enable-exampledir=/usr/share/doc/frr/examples/ --localstatedir=/var/run/frr --sbindir=/usr/lib/frr --sysconfdir=/etc/frr --enable-vtysh --enable-isisd --enable-pimd --enable-watchfrr --enable-ospfclient=yes --enable-ospfapi=yes --enable-multipath=64 --enable-user=frr --enable-group=frr --enable-vty-group=frrvty --enable-configfile-mask=0640 --enable-logfile-mask=0640 --enable-rtadv --enable-fpm --enable-ldpd --with-pkg-git-version --with-pkg-extra-version=-MyOwnFRRVersion --enable-rpki=yes --enable-sharpd --enable-usdt=yes && make -j$(nproc) && make install'
  config.vm.provision :shell, inline: 'install -m 755 -o frr -g frr -d /var/log/frr && install -m 755 -o frr -g frrvty -d /var/run/frr && install -m 775 -o frr -g frrvty -d /etc/frr && install -m 640 -o frr -g frr /dev/null /etc/frr/zebra.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/bgpd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ospfd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ospf6d.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/isisd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ripd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ripngd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/pimd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ldpd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/nhrpd.conf && install -m 640 -o frr -g frrvty /dev/null /etc/frr/vtysh.conf'
  config.vm.provision :shell, inline: 'cp /root/frr/tools/etc/frr/* /etc/frr'
  config.vm.provision :shell, inline: 'sed -i s/zebra=no/zebra=yes/ /etc/frr/daemons'
  config.vm.provision :shell, inline: 'sed -i s/bgpd=no/bgpd=yes/ /etc/frr/daemons'
  config.vm.provision :shell, inline: 'ldconfig'
  config.vm.provision :shell, inline: 'cp /usr/local/bin/vtysh /usr/bin/vtysh'
  config.vm.provision :shell, inline: 'cp /root/frr/tools/frr.service /etc/systemd/system/frr.service && systemctl daemon-reload && systemctl restart frr'
  config.vm.provision :shell, inline: 'systemctl enable frr'
end
