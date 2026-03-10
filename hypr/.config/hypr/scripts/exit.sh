#!/bin/bash

# Опции меню
options="Lock\nLogout\nSuspend\nReboot\nShutdown"

# Отображение меню через wofi
selected=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 300 --height 200 --style ~/.config/wofi/style.css)

case "$selected" in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend && hyprlock
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
