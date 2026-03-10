#!/bin/sh
vpns=$(nmcli -f NAME,TYPE con show | grep vpn | awk '{print $1}')  # Фильтр VPN-соединений
choice=$(echo "$vpns" | wofi --dmenu -p "Выбери VPN:")
if nmcli con show --active | grep -q "$choice"; then
    nmcli con down id "$choice"
else
    nmcli con up id "$choice"
fi
