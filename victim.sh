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
while sleep 5; do
    ip netns exec victim curl  --cookie "USER_TOKEN=SomeRandomInfoHere" http://192.168.101.1/
    ip netns exec victim /bin/sh -c "echo ls | smbclient -U victim  //192.168.101.1/victim supersekret"
done

