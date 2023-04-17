#!/bin/bash

SERVICE_NAME="saby"

SRC_DIR="/opt/misc"
DST_DIR="/srv/data"

UNIT_LIST=$(systemctl list-units --full -all | grep "$SERVICE_NAME-" | awk '{print $1}')

for UNIT in $UNIT_LIST; do
    systemctl stop $UNIT

    SERVICE=$(echo $UNIT | cut -d'-' -f2-)

    mv $SRC_DIR/$SERVICE $DST_DIR

    sed -i "s|WorkingDirectory=$SRC_DIR/$SERVICE|WorkingDirectory=$DST_DIR/$SERVICE|" /etc/systemd/system/$UNIT
    sed -i "s|ExecStart=$SRC_DIR/$SERVICE|ExecStart=$DST_DIR/$SERVICE/$SERVICE- daemon|" /etc/systemd/system/$UNIT

    systemctl start $UNIT
done