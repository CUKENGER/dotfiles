#!/bin/bash

declare -A icons
icons["firefox"]="󰈹"
icons["alacritty"]=""
icons["Alacritty"]=""
icons["code"]="󰨞"
icons["Code"]="󰨞"
icons["code-oss"]="󰨞"
icons["default"]="󰘔"

escape() {
    echo "$1" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g'
}

update_output() {
    current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

    clients=$(hyprctl clients -j | jq -c --arg ws "$current_ws" '
        [.[] 
        | select(.workspace.id == ($ws | tonumber)) 
        | {class, title, address}
        ] | sort_by(.address)
    ')

    if [ -z "$clients" ] || [ "$clients" = "[]" ]; then
        echo '{"text":""}'
        return
    fi

    active_addr=$(hyprctl activewindow -j | jq -r '.address // empty')

    text=""
    class="tabs"

    while read -r client; do
        class_name=$(echo "$client" | jq -r '.class')
        title=$(echo "$client" | jq -r '.title')
        addr=$(echo "$client" | jq -r '.address')

        case $class_name in
            firefox)
                title=$(echo "$title" | sed 's/ — Mozilla Firefox$//; s/ [Default]//')
                ;;
            alacritty|Alacritty)
                title=$(echo "$title" | sed 's/tmux .* - //; s/.*\///')
                ;;
            code|Code|code-oss)
                title=$(echo "$title" | sed -n 's/.* - \(.*\) - Visual Studio Code/\1/p')
                [ -z "$title" ] && title="VSCode"
                ;;
            *)
                title=$(echo "$title" | awk '{print $1}')
                ;;
        esac

        icon=${icons[${class_name,,}]:-${icons["default"]}}

        is_active=0
        [ "$addr" = "$active_addr" ] && is_active=1

        title=$(escape "$title")

        if [ "$is_active" -eq 1 ]; then
            text+=" <span foreground='#ffffff' background='#3b82f6'> $icon $title </span> "
        else
            text+=" <span> $icon $title </span> "
        fi

    done <<< "$(echo "$clients" | jq -c '.[]')"

    echo "{\"text\":\"$text\",\"class\":\"$class\",\"markup\":\"pango\"}"
}

update_output

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r event; do
case $event in
    activewindow*|workspace*|openwindow*|closewindow*|movewindow*)
        update_output
        ;;
esac
done
