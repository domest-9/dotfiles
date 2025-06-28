#!/bin/bash

OVERRIDE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"
ZPROFILE="$HOME/.zprofile"

ensure_zprofile_hypr() {
  grep -q "exec Hyprland" "$ZPROFILE" 2>/dev/null && return
  echo "Adding Hyprland autostart to $ZPROFILE..."
  cat <<'EOF' >> "$ZPROFILE"

# Auto-start Hyprland on TTY1
if [[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]]; then
  exec Hyprland
fi
EOF
}

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
  ensure_zprofile_hypr
fi

