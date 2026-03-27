#!/bin/bash
ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name')
WINDOW_WS=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [[ "$WINDOW_WS" == "special:scratchpad" ]]; then
  # вернуть окно в исходный workspace
  hyprctl dispatch movetoworkspace "$CURRENT_WS"
else
  # переместить в scratchpad и показать его
  hyprctl dispatch movetoworkspace special:scratchpad
  hyprctl dispatch togglespecialworkspace scratchpad
fi
