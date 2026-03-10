#!/bin/bash

# Получаем список окон в scratchpad
clients=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:scratchpad") | "\(.address) \(.title)"')

# Если пусто, выход
if [ -z "$clients" ]; then
    notify-send "Scratchpad пуст"
    exit 0
fi

# Показываем в wofi
selected=$(echo "$clients" | wofi --dmenu -p "Выбери окно из scratchpad:")

# Если выбрано, перемещаем только выбранное окно в текущий workspace и включаем тайлинг
if [ -n "$selected" ]; then
    address=$(echo "$selected" | awk '{print $1}')
    # Перемещаем окно в текущий workspace
    hyprctl dispatch movetoworkspace name:$(hyprctl activeworkspace -j | jq -r '.name'),address:$address
    # Принудительно включаем тайлинг для окна
    hyprctl dispatch togglefloating off,address:$address
fi
