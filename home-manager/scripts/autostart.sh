#!/usr/bin/env bash

# Wait for the Wayland socket to appear
while [ ! -S "$XDG_RUNTIME_DIR/wayland-1" ]; do sleep 0.1; done

# Load OpenRGB profile and minimize
openrgb --profile Default --startminimized &

# Set cursor theme and size
hyprctl setcursor capitaine-cursors 24

# Restart user services
systemctl --user restart \
  hyprpaper.service \
  wlsunset.service \
  waybar.service \
  blueman-applet.service
