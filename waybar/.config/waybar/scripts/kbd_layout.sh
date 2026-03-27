#!/bin/bash

# получаем индекс активной раскладки
idx=$(hyprctl devices -j | jq -r '
  (.keyboards[] | select(.main == true) | .active_layout_index) // 
  (.keyboards[0].active_layout_index)
')

# получаем список раскладок из конфига
layouts=$(hyprctl getoption input:kb_layout -j | jq -r '.str')
IFS=',' read -ra arr <<< "$layouts"

current="${arr[$idx]}"

case "$current" in
  us*) echo "US" ;;
  ru*) echo "RU" ;;
  de*) echo "DE" ;;
  *) echo " $current" ;;
esac
