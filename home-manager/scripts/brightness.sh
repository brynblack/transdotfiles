#!/usr/bin/env bash

# Set brightness to specified level
hyprctl hyprsunset gamma "$1"

# Get current brightness level
BRIGHTNESS=$(hyprctl hyprsunset gamma)
PERCENT=$(awk "BEGIN {printf \"%.0f\", $BRIGHTNESS}")

# Send notification
notify-send -h string:x-canonical-private-synchronous:volume \
            -h int:value:"$PERCENT" \
            -t 2000 \
            -u low "Brightness" "${PERCENT}%"
