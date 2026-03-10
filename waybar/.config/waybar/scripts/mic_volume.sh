#!/bin/bash
VOLUME=$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{print $2 * 100}')
MUTED=$(wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED" && echo "true" || echo "false")
if [ "$MUTED" = "true" ]; then
    echo '{"percentage": 0, "icon": "🔇"}'
else
    echo "{\"percentage\": $VOLUME, \"icon\": \"\"}"
fi
