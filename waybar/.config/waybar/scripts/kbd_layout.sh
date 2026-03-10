#!/bin/bash

# получаем индекс активной раскладки у main-клавиатуры
idx=$(hyprctl devices -j | jq -r '
  .keyboards[]
  | select(.main == true)
  | .active_layout_index
')

# fallback — первая клавиатура
if [ -z "$idx" ] || [ "$idx" = "null" ]; then
  idx=$(hyprctl devices -j | jq -r '.keyboards[0].active_layout_index')
fi

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
