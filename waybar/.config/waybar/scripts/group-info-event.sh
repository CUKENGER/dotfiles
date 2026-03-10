#!/bin/bash

# Инициализация иконок и логики обработки (копия из group-info.sh)
declare -A icons
icons["firefox"]="󰈹"
icons["alacritty"]=""
icons["Alacritty"]=""
icons["code"]="󰨞"
icons["Code"]="󰨞"
icons["code-oss"]="󰨞"
icons["default"]="󰘔"

function update_output {
    current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    clients=$(hyprctl clients -j | jq -c --arg ws "$current_ws" '[.[] | select(.workspace.id == ($ws | tonumber) and (.grouped | type == "array") and (.grouped | length > 0)) | {class: .class, title: .title, address: .address}] | sort_by(.address)')

    if [ -z "$clients" ] || [ "$clients" = "[]" ]; then
        echo '{"text":""}'
        return
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
                [ -z "$title" ] && title="VSCode"
                ;;
            *)
                title=$(echo "$title" | sed 's/\([^ ]*\).*/\1/')
                [ ${#title} -gt 15 ] && title="${title:0:12}..."
                ;;
        esac
        icon=${icons[${class,,}]:-${icons["default"]}}
        padded_title=$(printf "%-15s" "$title")
        class_name="group-tabs"
        [ "$addr" = "$active_addr" ] && class_name="group-tabs active"
        [ "$addr" = "$active_addr" ] && text="$icon $padded_title •" || text="$icon $padded_title"
        tabs+=("{\"text\":\"$text\",\"class\":\"$class_name\"}")
    done <<< "$(echo "$clients" | jq -c '.[]')"

    if [ ${#tabs[@]} -eq 0 ]; then
        echo '{"text":""}'
    else
        output=$(printf '%s\n' "${tabs[@]}" | jq -s -r 'map(.text) | join(" | ")')
        class=$(printf '%s\n' "${tabs[@]}" | jq -s -r 'map(.class) | join(" ")')
        echo "{\"text\":\"$output\",\"class\":\"$class\"}"
    fi
}

# Первичный вывод
update_output

# Подписка на события Hyprland
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r event; do
case $event in
    activewindow* | workspace* | openwindow* | closewindow* | movewindow*)
        update_output
        ;;
esac
done
