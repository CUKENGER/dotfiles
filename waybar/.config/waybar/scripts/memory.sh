#!/bin/bash

total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
free=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)

used=$((total - free))
percent=$((used * 100 / total))

used_gb=$(awk "BEGIN {printf \"%.1f\", $used/1024/1024}")
total_gb=$(awk "BEGIN {printf \"%.1f\", $total/1024/1024}")

echo "${used_gb}G/${total_gb}G (${percent}%)"
