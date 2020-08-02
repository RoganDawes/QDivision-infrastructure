#!/bin/sh
cd $( cd $(dirname $0) && pwd)

printf "lan\tplatform-1c1b000.usb-usb-0:1:1.0\nwan\tplatform-1c30000.ethernet\n" | while read iface path; do
cat << EOF > /etc/systemd/network/10-$iface.link
[Match]
Path=$path

[Link]
Name=$iface
EOF
done

apt update
DEBIAN_FRONTEND=noninteractive apt install -y dnsmasq lighttpd samba smbclient php7.3-cgi

adduser --disabled-password --gecos "" victim
printf "supersekret\nsupersekret\n" | passwd victim
printf "supersekret\nsupersekret\n"  | smbpasswd -a victim

mkdir -p /etc/netns/victim/ && echo nameserver 192.168.101.1 > /etc/netns/victim/resolv.conf
printf "127.0.0.1 localhost\n" > /etc/netns/victim/hosts

cp interfaces /etc/network/interfaces
cp dnsmasq.conf /etc/dnsmasq.conf
cp NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
cp index.php /var/www/html/
cp hosts /etc/hosts

lighty-enable-mod fastcgi 
lighty-enable-mod fastcgi-php
service lighttpd force-reload

printf '#!/bin/sh -e\n/root/QDivision-infrastructure/victim.sh > /dev/null 2| logger & \n\n' > /etc/rc.local
