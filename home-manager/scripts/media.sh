#!/usr/bin/env bash

playerctl $1
exit_code=$?

if [ $exit_code -ne 0 ]; then
  exit 1
fi

action=""

case "$1" in
  "previous") action="Previous" ;;
  "play-pause") action=$(playerctl status) ;;
  "next") action="Next" ;;
esac

notify-send -h string:x-canonical-private-synchronous:volume \
            -u low \
            -t 2000 \
            "Media" "$action"
