#!/bin/sh
active_vpn=$(nmcli -f NAME,TYPE con show --active | grep vpn | awk '{print $1}')
if [ -n "$active_vpn" ]; then
    echo "$active_vpn"
else
    echo "OFF"
fi
