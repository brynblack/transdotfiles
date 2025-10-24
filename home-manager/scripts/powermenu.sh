#!/usr/bin/env bash

pkill wofi

chosen=$(printf " Lock\n⏾ Sleep\n↩ Logout\n⭮ Reboot\n⏻ Shutdown" | wofi --dmenu --cache-file /dev/null)

case "$chosen" in
    " Lock") loginctl lock-session ;;
    "⏾ Sleep") systemctl suspend ;;
    "↩ Logout") hyprctl dispatch exit 0 ;;
    "⭮ Reboot") systemctl reboot ;;
    "⏻ Shutdown") systemctl poweroff ;;
esac
