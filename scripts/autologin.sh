#!/bin/bash

OVERRIDE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

if [ -f "$OVERRIDE_FILE" ]; then
  echo "Autologin override exists. Disabling autologin..."
  sudo rm "$OVERRIDE_FILE"
  sudo systemctl daemon-reload
  echo "Autologin disabled. You will be prompted for password at login."
else
  echo "No autologin override found. Enabling autologin for user $USER..."
  sudo mkdir -p "$OVERRIDE_DIR"
  sudo tee "$OVERRIDE_FILE" > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOF
  sudo systemctl daemon-reload
  echo "Autologin enabled. System will auto login user $USER on TTY1."
fi

