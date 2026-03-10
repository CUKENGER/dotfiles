#!/bin/bash
ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.name')
WINDOW_WORKSPACE=$(hyprctl clients -j | jq -r --arg addr "$ACTIVE_WINDOW" '.[] | select(.address == $addr) | .workspace.name')

if [[ "$WINDOW_WORKSPACE" == "special:scratchpad" ]]; then
  hyprctl dispatch movetoworkspace "$CURRENT_WORKSPACE"
else
  hyprctl dispatch togglefloating
  hyprctl dispatch movetoworkspace special:scratchpad
	hyprctl dispatch togglespecialworkspace scratchpad
fi
