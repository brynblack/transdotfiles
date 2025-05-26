#!/usr/bin/env bash

# Check if argument is given (volume level)
if [ -n "$1" ]; then
    # --- Set Volume Mode ---
    
    # Set volume to specified level
    wpctl set-volume --limit 1.0 @DEFAULT_SINK@ "$1"

    # Get current volume level
    VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
    PERCENT=$(awk "BEGIN {printf \"%d\", $VOLUME * 100}")

    # Send notification
    notify-send -h string:x-canonical-private-synchronous:volume \
                -h int:value:"$PERCENT" \
                -t 2000 \
                -u low "Volume" "${PERCENT}%"
else
    # --- Toggle Mute Mode ---

    # Toggle mute
    wpctl set-mute @DEFAULT_SINK@ toggle

    # Get current volume and mute status
    STATUS=$(wpctl get-volume @DEFAULT_SINK@)
    LEVEL=$(echo "$STATUS" | awk '{print $2}')
    PERCENT=$(awk "BEGIN {printf \"%d\", $LEVEL * 100}")

    if echo "$STATUS" | grep -q '\[MUTED\]'; then
        notify-send -h string:x-canonical-private-synchronous:volume \
                    -u low \
                    -t 2000 \
                    "Volume" "Muted"
    else
        notify-send -h string:x-canonical-private-synchronous:volume \
                    -h int:value:"$PERCENT" \
                    -u low \
                    -t 2000 \
                    "Volume" "${PERCENT}%"
    fi
fi
