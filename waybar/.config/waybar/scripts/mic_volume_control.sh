#!/bin/bash
case $1 in
    up)
        wpctl set-volume @DEFAULT_SOURCE@ 5%+
        ;;
    down)
        wpctl set-volume @DEFAULT_SOURCE@ 5%-
        ;;
esac
