#!/bin/sh

printf "lan\tplatform-1c1b000.usb-usb-0:1:1.0\nwan\tplatform-1c30000.ethernet\n" | while read iface path; do
cat << EOF > /etc/systemd/network/10-$iface.link
[Match]
Path=$path

[Link]
Name=$iface
EOF
done

cat << EOF >> /etc/NetworkManager/NetworkManager.conf

[keyfile]
unmanaged-devices=interface-name:wan,interface-name:lan

EOF



apt update
DEBIAN_FRONTEND=noninteractive apt install -y dnsmasq lighttpd samba smbclient

adduser --disabled-password --gecos "" victim
printf "supersekret\nsupersekret\n" | passwd victim
printf "supersekret\nsupersekret\n"  | smbpasswd -a victim

cp interfaces /etc/config/interfaces
cp dnsmasq.conf /etc/dnsmasq.conf
cp NetworkManager.conf /etc/MetworkManager/NetworkManager.conf


