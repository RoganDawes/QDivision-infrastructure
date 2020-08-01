#!/bin/sh

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

cp interfaces /etc/network/interfaces
cp dnsmasq.conf /etc/dnsmasq.conf
cp NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
cp index.php /var/www/html/
cp hosts /etc/hosts

lighty-enable-mod fastcgi 
lighty-enable-mod fastcgi-php
service lighttpd force-reload


