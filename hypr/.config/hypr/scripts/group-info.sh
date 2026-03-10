#!/bin/bash

declare -A icons
icons["firefox"]="󰈹"  # Браузер
icons["alacritty"]=""  # Терминал
icons["Alacritty"]=""  # Терминал
icons["code"]="󰨞"    # VS Code
icons["Code"]="󰨞"    # Для случая с большой буквы
icons["code-oss"]="󰨞" # Для Code OSS
icons["default"]="󰘔" # Дефолт

current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
clients=$(hyprctl clients -j | jq -c --arg ws "$current_ws" '[.[] | select(.workspace.id == ($ws | tonumber) and (.grouped | type == "array") and (.grouped | length > 0)) | {class: .class, title: .title, address: .address}] | sort_by(.address)')

if [ -z "$clients" ] || [ "$clients" = "[]" ]; then
  echo '{"text":""}'
  exit 0
fi

active_addr=$(hyprctl activewindow -j | jq -r '.address // empty')

tabs=()
while read -r client; do
  class=$(echo "$client" | jq -r '.class')
  title=$(echo "$client" | jq -r '.title')
  addr=$(echo "$client" | jq -r '.address')
  case $class in
    firefox)
      title=$(echo "$title" | sed 's/ — Mozilla Firefox$//; s/ [Default]//; s/\([^ ]*\).*/\1/')
      ;;
    alacritty|Alacritty)
      title=$(echo "$title" | sed 's/tmux .* - //; s/.*\///; s/\([^ ]*\).*/\1/')
      ;;
    code|Code|code-oss)
      title=$(echo "$title" | sed -n 's/.* - \(.*\) - Visual Studio Code/\1/p')
      if [ -z "$title" ]; then
          title="VSCode"
      fi
      ;;
    *)
      title=$(echo "$title" | sed 's/\([^ ]*\).*/\1/')
      if [ ${#title} -gt 15 ]; then
        title="${title:0:12}..."
      fi
      ;;
  esac
  icon=${icons[${class,,}]:-${icons["default"]}}
  padded_title=$(printf "%-15s" "$title")
  class_name="group-tabs"
  if [ "$addr" = "$active_addr" ]; then
      class_name="group-tabs active"
  fi
if [ "$addr" = "$active_addr" ]; then
    tabs+=("{\"text\":\"$icon $padded_title •\",\"class\":\"$class_name\"}")
else
    tabs+=("{\"text\":\"$icon $padded_title\",\"class\":\"$class_name\"}")
fi
done <<< "$(echo "$clients" | jq -c '.[]')"

if [ ${#tabs[@]} -eq 0 ]; then
    echo '{"text":""}'
else
    output=$(printf '%s\n' "${tabs[@]}" | jq -s -r 'map(.text) | join(" | ")')
    class=$(printf '%s\n' "${tabs[@]}" | jq -s -r 'map(.class) | join(" ")')
    echo "{\"text\":\"$output\",\"class\":\"$class\"}"
fi
