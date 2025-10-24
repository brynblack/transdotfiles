#!/usr/bin/env bash

SERVICE="wlsunset.service"

if systemctl is-active --user "$SERVICE"; then
  systemctl stop --user "$SERVICE"
else
  systemctl start --user "$SERVICE"
fi
