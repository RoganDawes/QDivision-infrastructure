#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	kill $DHCLIENT
        ip netns exec victim ip link set lan netns 1
	ip netns delete victim
	exit
}

ip netns add victim
ip link set lan netns victim
ip netns exec victim dhclient -cf ./dhclient.conf -i lan -d &
DHCLIENT=$!
sleep 5
while : ; do
while ! ip netns exec victim ip a show dev lan | grep -q "inet "; do
	echo "Is the bridge on the attacker up? Can't get an IP address!"
	sleep 5
done
while ip netns exec victim ip a show dev lan | grep -q "inet "; do
    ip netns exec victim curl -d 'username=admin&password=neverguess' --cookie "USER_TOKEN=SomeRandomInfoHere" http://app/

    ip netns exec victim /bin/sh -c "echo ls | smbclient -U victim  //192.168.101.1/victim supersekret"
    sleep 5
done
done
