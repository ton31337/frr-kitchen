Vagrant.configure(2) do |config|
  config.vm.provision :shell, inline: 'dnf install -y epel-release'
  config.vm.provision :shell, inline: 'dnf -y --enablerepo=PowerTools install c-ares-devel texinfo bison byacc flex json-c-devel systemd-devel git gawk make readline-devel net-snmp-devel pkgconfig pcre-devel libtool automake autoconf python2 python2-devel python3-sphinx rpm-build net-snmp-devel pam-devel libcap-devel'
  config.vm.provision :shell, inline: 'groupadd --system --gid 92 frr && groupadd --system --gid 95 frrvty && adduser --system --gid frr --home /var/opt/frr --shell /bin/false frr && usermod -a -G frrvty frr'
  config.vm.provision :shell, inline: 'git clone https://github.com/ton31337/frr /root/frr'
  config.vm.provision :shell, inline: 'wget -O libyang.rpm https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/CentOS-7-x86_64-Packages/libyang-0.16.111-0.x86_64.rpm'
  config.vm.provision :shell, inline: 'wget -O libyang-devel.rpm https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/CentOS-7-x86_64-Packages/libyang-devel-0.16.111-0.x86_64.rpm'
  config.vm.provision :shell, inline: 'rpm -i libyang.rpm libyang-devel.rpm'
  config.vm.provision :shell, inline: 'cd /root/frr && ./bootstrap.sh'
  config.vm.provision :shell, inline: 'cd /root/frr && ./configure --enable-systemd --enable-exampledir=/usr/share/doc/frr/examples/ --localstatedir=/var/opt/frr --sbindir=/usr/lib/frr --sysconfdir=/etc/frr --enable-vtysh --enable-isisd --enable-pimd --enable-watchfrr --enable-ospfclient=yes --enable-ospfapi=yes --enable-multipath=64 --enable-user=frr --enable-group=frr --enable-vty-group=frrvty --enable-configfile-mask=0640 --enable-logfile-mask=0640 --enable-rtadv --enable-fpm --enable-ldpd --with-pkg-git-version --with-pkg-extra-version=-MyOwnFRRVersion && make && make install'
  config.vm.provision :shell, inline: 'install -m 755 -o frr -g frr -d /var/log/frr && install -m 755 -o frr -g frr -d /var/opt/frr && install -m 775 -o frr -g frrvty -d /etc/frr && install -m 640 -o frr -g frr /dev/null /etc/frr/zebra.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/bgpd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ospfd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ospf6d.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/isisd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ripd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ripngd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/pimd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/ldpd.conf && install -m 640 -o frr -g frr /dev/null /etc/frr/nhrpd.conf && install -m 640 -o frr -g frrvty /dev/null /etc/frr/vtysh.conf'
  config.vm.provision :shell, inline: 'cp -a /root/frr/tools/etc/frr/* /etc/frr'
  config.vm.provision :shell, inline: 'sed -i s/zebra=no/zebra=yes/ /etc/frr/daemons'
  config.vm.provision :shell, inline: 'sed -i s/bgpd=no/bgpd=yes/ /etc/frr/daemons'
  config.vm.provision :shell, inline: 'ldconfig'
  config.vm.provision :shell, inline: 'cp /usr/local/bin/vtysh /usr/bin/vtysh'
  config.vm.provision :shell, inline: 'cp /root/frr/tools/frr.service /etc/systemd/system/frr.service && systemctl daemon-reload && systemctl restart frr'
  config.vm.provision :shell, inline: 'systemctl enable frr'
  config.vm.provision :shell, inline: 'cd /root/frr && make dist'
  config.vm.provision :shell, inline: 'mkdir -p /root/frr/rpmbuild/{SOURCES,SPECS}'
  config.vm.provision :shell, inline: 'cp /root/frr/redhat/*.spec /root/frr/rpmbuild/SPECS'
  config.vm.provision :shell, inline: 'cp /root/frr/frr*.tar.gz /root/frr/rpmbuild/SOURCES'
end
