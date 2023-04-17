#!/bin/bash

SERV_LIST="servers.txt"

UNRESOLVABLE_SERV=""
UNREACHABLE_SERV=""
REACHABLE_SERV=""

while read SERVER; do
    IP=$(dig +short $SERVER)

    if [[ -z "$IP" ]]; then
        UNRESOLVABLE_SERV+="\n$SERVER"
    else
        if ping -c 1 $IP >/dev/null 2>&1; then
            REACHABLE_SERV+="\n$SERVER, $IP"
        else
            UNREACHABLE_SERV+="\n$SERVER, $IP"
        fi
    fi
done < "$SERVER_LIST"