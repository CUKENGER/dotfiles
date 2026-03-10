#!/bin/bash
MAX_VOLUME=160 # Лимит 150%
CURRENT_VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

if [ "$1" == "up" ]; then
  if [ $CURRENT_VOLUME -lt $MAX_VOLUME ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +5%
  fi
elif [ "$1" == "down" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
fi
